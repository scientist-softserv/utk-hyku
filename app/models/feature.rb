class Feature < ActiveRecord::Base
  extend Flip::Declarable

  strategy Flip::CookieStrategy
  strategy Flip::DatabaseStrategy
  strategy Flip::DeclarationStrategy
  default false
end
