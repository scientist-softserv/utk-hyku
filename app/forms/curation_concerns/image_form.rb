# Generated via
#  `rails generate curation_concerns:work Image`
module CurationConcerns
  class ImageForm < Sufia::Forms::WorkForm
    self.model_class = ::Image
    self.terms += [:resource_type]
  end
end
