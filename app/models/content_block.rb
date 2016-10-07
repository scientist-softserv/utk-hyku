class ContentBlock < ActiveRecord::Base
  include Sufia::ContentBlockBehavior
  include Lerna::ContentBlockBehavior
end
