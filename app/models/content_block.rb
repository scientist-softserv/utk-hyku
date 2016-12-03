class ContentBlock < ActiveRecord::Base
  include Hyrax::ContentBlockBehavior
  include Hyku::ContentBlockBehavior
end
