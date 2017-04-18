# Generated via
#  `rails generate curation_concerns:work Image`
module Hyrax
  class ImageForm < Hyrax::Forms::WorkForm
    self.model_class = ::Image
    self.terms += [:resource_type, :extent]
  end
end
