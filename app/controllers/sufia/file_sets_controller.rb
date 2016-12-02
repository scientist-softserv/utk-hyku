module Sufia
  class FileSetsController < ApplicationController
    include Sufia::FileSetsControllerBehavior
    include Sufia::FileSetsControllerBehavior
    self.show_presenter = Hyku::FileSetPresenter
  end
end
