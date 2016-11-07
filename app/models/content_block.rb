class ContentBlock < ActiveRecord::Base
  include Sufia::ContentBlockBehavior
  include Hyku::ContentBlockBehavior
end
