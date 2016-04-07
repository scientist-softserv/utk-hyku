module SufiaHelper
  include ::BlacklightHelper
  include CurationConcerns::MainAppHelpers
  include Sufia::BlacklightOverride
  include Sufia::SufiaHelperBehavior

  def application_name
    Site.instance.application_name || super
  end
end
