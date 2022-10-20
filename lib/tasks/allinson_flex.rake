# frozen_string_literal: true

namespace :allinson_flex do
  desc "Additional configurations necessary for allinson flex profile management"
  task run_additional_configurations: :environment do
    Account.find_each do |account|
      next if account.name == "search"
      switch!(account)

      puts "=============== configuring #{account.name} ============"
      work_types = AllinsonFlex::DynamicSchema.all.map(&:allinson_flex_class).uniq
      work_types -= ["FileSet"] if work_types.include?("FileSet")
      update_indexers(work_types: work_types)
      update_presenters(work_types: work_types)
      puts "=============== finished configuring #{account.name} ============"
    end
  end

  def update_indexers(work_types:)
    work_types.each do |work_type|
      file = "app/indexers/#{work_type.underscore}_indexer.rb"
      content = File.read(file).gsub(/\< Hyrax\:\:WorkIndexer/, '< AppIndexer')
      File.open(file, 'wb') { |f| f.write(content) }
    end
  end

  def update_presenters(work_types:)
    work_types.each do |work_type|
      file = "app/presenters/hyrax/#{work_type.underscore}_presenter.rb"
      content = File.read(file).gsub(/\< Hyrax\:\:WorkShowPresenter/, '< Hyku::WorkShowPresenter')
      File.open(file, 'wb') { |f| f.write(content) }
    end
  end
end
