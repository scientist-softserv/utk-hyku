module CurationConcerns
  class FileSetsController < ApplicationController
    include CurationConcerns::FileSetsControllerBehavior
    include Sufia::FileSetsControllerBehavior
    self.show_presenter = Lerna::FileSetPresenter
  end
end
