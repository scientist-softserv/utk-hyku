# frozen_string_literal: true

module Admin
  class QaFilesController < AdminController
    def csvs; end

    def generate_csvs
      uqc = UniqueQaCsvs.new
      uqc.run
      send_file uqc.output_path + '/qa.zip'
    end
  end
end
