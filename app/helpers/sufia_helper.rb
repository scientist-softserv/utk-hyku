module SufiaHelper
  include ::BlacklightHelper
  include CurationConcerns::MainAppHelpers
  include Sufia::BlacklightOverride
  include Sufia::SufiaHelperBehavior

  def application_name
    Site.application_name || super
  end
end
