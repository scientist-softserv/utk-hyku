module CurationConcerns
  class FileSetsController < ApplicationController
    include CurationConcerns::FileSetsControllerBehavior
    self.show_presenter = Lerna::FileSetPresenter
  end
end
