# frozen_string_literal: true

class UniqueQaCsvs
  attr_accessor :input_path, :output_path, :output_subpath, :datestamp
  def initialize(input_path: Rails.root.join('spec', 'fixtures', 'utk', '366-367'), output_path: Dir.mktmpdir)
    @input_path = File.expand_path(input_path)
    @output_path = File.expand_path(output_path)
    @output_subpath = @output_path + '/qa'
    FileUtils.mkdir(@output_subpath)
    @datestamp = Time.zone.now.strftime("%Y%m%d%H%M:")
  end

  def run
    Dir.glob("#{input_path}/*.csv").each do |csv_file|
      Rails.logger.debug "Processing #{csv_file}"
      CSV.open(csv_file, headers: true) do |in_csv|
        # We load the first row to get the headers, then we write the first row to the output file
        # this prevents reading the whole file in to memory but still gets us access to the headers
        first_row = in_csv.first
        first_row['source_identifier'] = modify_value(first_row['source_identifier'])
        first_row['parents'] = modify_value(first_row['parents'])

        out_csv_path = File.join(output_subpath, File.basename(csv_file))
        CSV.open(out_csv_path, 'w', headers: in_csv.headers, write_headers: true) do |out_csv|
          out_csv << first_row
          in_csv.each do |row|
            row['source_identifier'] = modify_value(row['source_identifier'])
            row['parents'] = modify_value(row['parents'])
            out_csv << row
          end
        end
      end
    end

    `zip -r #{output_path}/qa.zip #{output_subpath}`
  end

  def modify_value(value)
    value.gsub(/^.+:/, datestamp)
  end
end
