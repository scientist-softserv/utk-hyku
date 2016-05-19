module CurationConcerns
  class FileSetsController < ApplicationController
    include CurationConcerns::FileSetsControllerBehavior
    self.show_presenter = Hybox::FileSetPresenter
  end
end
