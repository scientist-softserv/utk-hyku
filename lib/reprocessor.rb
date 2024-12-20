# frozen_string_literal: true

require 'singleton'
require 'ruby-progressbar'

## Reprocessor for iterating through large sets of ids
# There are two steps for any reprocessing. The first is to store all the ids to processin a ids.log file.
# The second to to run a lambda against every id
# No matter whether it is the first run or not, a run of the Reprocessor should
# always start with Reprocessor.load('tmp/imports/SOME_UNIQUE_NAME')
# This creates a context for the Reprocessor to run.
# After that, calling Reprocessor.capture_ids (or capture_work_ids, capture_file_set_ids or capture collection_ids)
# will record all the ids in a file
# finally, once all the ids are split, then calling Reprocessor.process_ids with a lambda
# (like Reprocessor.process_ids(Reprocessor.save)) to call the process on each item
# At any point, the process can be stopped (or killed) and then resumed by doing Reprocessor.load(SAME_PATH)
# and then calling the process_ids again.
class Reprocessor # rubocop:disable Metrics/ClassLength
  include Singleton

  SETTINGS = %w[header_lines batch_size current_location limit incremental_save log_dir].freeze

  attr_accessor(*SETTINGS)
  def initialize
    @header_lines = 1
    @batch_size   = 1000
    @current_location = 0
    @limit = nil
    @incremental_save = true
    @log_dir = 'tmp/imports'
    super
  end

  # Missing methods will be delegated to `instance` if an implementation is available.
  # Else `NoMethodError` will be raised via call to `super`
  # rubocop:disable Style/MethodMissing
  # rubocop:disable Rails/Output
  def self.method_missing(method_name, *args)
    if instance.respond_to? method_name
      puts "** Defining new method: '#{method_name}'"
      (class << self; self; end).instance_eval do
        define_method(method_name) do |*args_i|
          instance.send(method_name, *args_i)
        end
      end
      instance.send(method_name, *args)
    else
      super
    end
  end
  # rubocop:enable Style/MethodMissing
  # rubocop:enable Rails/Output

  SETTINGS.each do |method|
    define_singleton_method(method) do |*args|
      instance.send(method, *args)
    end

    define_singleton_method("#{method}=") do |*args|
      instance.send("#{method}=", *args)
    end
  end

  def self.load(log_dir = Rails.root.join('tmp', 'imports').to_s)
    state = JSON.parse(File.read("#{log_dir}/work_processor.json"))
    SETTINGS.each do |setting|
      instance.send("#{setting}=", state[setting])
    end
  rescue Errno::ENOENT
    puts 'no save file to load' # rubocop:disable Rails/Output
    instance.log_dir = log_dir
  end

  def self.save
    state = {}
    SETTINGS.each do |setting|
      state[setting] = instance.send(setting)
    end
    File.write("#{instance.log_dir}/work_processor.json", state.to_json)
  end

  def capture_ids
    capture_collection_ids
    capture_work_ids
    capture_file_set_ids
  end

  def capture_work_ids
    Hyrax.config.query_index_from_valkyrie = false
    search = "has_model_ssim:(#{Bulkrax.curation_concerns.join(' OR ')})"
    caputre_with_solr(search)
  end

  def capture_file_set_ids
    Hyrax.config.query_index_from_valkyrie = false
    search = "has_model_ssim:(FileSet)"
    caputre_with_solr(search)
  end

  def capture_collection_ids
    Hyrax.config.query_index_from_valkyrie = false
    search = "has_model_ssim:(Collection)"
    caputre_with_solr(search)
  end

  def caputre_with_solr(search)
    count = Hyrax::SolrService.count(search)
    progress(count)
    while current_location < count
      break if limit && current_location >= limit
      ids = Hyrax::SolrService.query(search, fl: 'id', rows: batch_size, start: current_location)
      self.current_location += batch_size
      ids.each do |i|
        id_log.error(i['id'])
      end
      progress.progress = [self.current_location, count].min
      Reprocessor.save if incremental_save
    end
  end

  def capture_bulkrax_entry_ids(query)
    count = query.count
    progress(count)
    i = 0
    query.find_each do |entry|
      next if i < self.current_location
      break if limit && i >= limit
      id_log.error(entry.id)
      progress.increment
      i += 1
      self.current_location += 1
      Reprocessor.save if incremental_save
    end
  end

  def process_ids(lamb)
    progress(id_line_size)
    line_counter = 0
    with_id_lines do |lines|
      lines.each do |line|
        line_counter += 1
        if line_counter < current_location
          progress.increment
          next
        end
        break if limit && current_location >= limit
        begin
          lamb.call(line, progress)
        rescue StandardError => e
          error(line, e)
        end
        self.current_location += 1
        progress.increment
        Reprocessor.save if incremental_save
      end
      # double break to get out of the lazy loop
      break if limit && current_location >= limit
    end
  end

  def error(line, exception)
    msg = "#{line} - #{exception.message[0..200]}"
    error_log.error(msg)
  end

  def error_log
    @error_log ||= ActiveSupport::Logger.new("#{log_dir}/error.log")
  end

  def id_path
    @id_path ||= "#{log_dir}/ids.log"
  end

  def id_log
    @id_log ||= ActiveSupport::Logger.new(id_path)
  end

  def id_line_size
    @id_line_size ||= `wc -l #{id_path}`.split.first.to_i
  end

  def with_id_lines
    File.open(id_path) do |file|
      file.lazy.drop(header_lines).each_slice(batch_size) do |lines|
        yield lines
      end
    end
  end

  def gone
    @gone ||= ActiveSupport::Logger.new("#{log_dir}/gone.log")
  end

  def no_bulkrax
    @no_bulkrax ||= ActiveSupport::Logger.new("#{log_dir}/no_bulkrax.log")
  end

  def re_run
    @re_run ||= ActiveSupport::Logger.new("#{log_dir}/re_run.log")
  end

  def upstream_issue
    @upstream_issue ||= ActiveSupport::Logger.new("#{log_dir}/upstream_issue.log")
  end

  def unknown
    @unknown ||= ActiveSupport::Logger.new("#{log_dir}/unknown.log")
  end

  def file_errors(line)
    id = line.strip
    begin
      file_set = FileSet.find(id)
    rescue Ldp::Gone, ActiveFedora::ObjectNotFoundError
      gone.error(id)
      return
    end
    if file_set.bulkrax_identifier
      entry = Bulkrax::Entry.find_by(identifier: file_set.bulkrax_identifier)
    else
      no_bulkrax.error(id)
      return
    end

    if entry
      result = `curl #{entry.parsed_metadata['remote_files'].first['url']}`
    else
      no_bulkrax.error(id)
      return
    end

    if result.blank?
      parent = file_set.member_of.first
      upstream_issue.error(["https://digitalcollections.lib.utk.edu/concern/attachments/#{parent.id}",
                            entry.parsed_metadata['remote_files'].first['url']])
      return
    end

    re_run.error(line)
  rescue StandardError => e
    unknown.error([line, e.message])
  end

  def lambda_file_errors
    @lambda_file_errors ||= lambda { |line, _progress|
      file_errors(line)
    }
  end

  # rubocop:disable Rails/Output
  def lambda_missing_files
    @lambda_missing_files ||= lambda { |line, _progress|
      id = line.strip
      if FileSet.find(id).files.blank?
        Reprocessor.instance.error_log.error(id)
        puts "no files found for #{id}"
      end
    }
  end
  # rubocop:enable Rails/Output

  def lambda_create_relationships
    @lambda_create_relationships ||= lambda { |line, _progress|
      id = line.strip
      e = Bulkrax::Entry.find(id)
      ::SEEN ||= [] # rubocop:disable Style/MutableConstant
      unless ::SEEN.include?(e.importer.id)
        ::SEEN << e.importer.id
        e.parser.create_parent_child_relationships
      end
    }
  end

  def lambda_save
    @lambda_save ||= lambda { |line, _progress|
      id = line.strip
      w = Hyrax.query_service.find_by(id: id)
      w.save
    }
  end

  # because this takes an arg, we dont memoize
  def lambda_reindex_job
    @lambda_job = lambda { |line, _progress|
      id = line.strip
      ReindexItemJob.perform_later(id)
    }
  end

  def lambda_af_index
    @lambda_af_index ||= lambda { |line, _progress|
      id = line.strip
      w = ActiveFedora::Base.find(id)
      w.update_index
    }
  end

  def lambda_index
    @lambda_index ||= lambda { |line, _progress|
      id = line.strip
      w = Hyrax.query_service.find_by(id: id)
      Hyrax.index_adapter.save(resource: w)
    }
  end

  def lambda_print
    @lambda_print ||= lambda { |line, progress|
      id = line.strip
      progress.log id
    }
  end

  def progress(total = nil)
    if total
      @progress = ProgressBar.create(total: total,
                                     format: "%a %b\u{15E7}%i %c/%C %p%% %t",
                                     progress_mark: ' ',
                                     remainder_mark: "\u{FF65}")
    else
      @progress
    end
  end
end
