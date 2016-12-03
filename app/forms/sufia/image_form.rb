# Generated via
#  `rails generate curation_concerns:work Image`
module Sufia
  class ImageForm < Sufia::Forms::WorkForm
    self.model_class = ::Image
    self.terms += [:resource_type]
  end
end
