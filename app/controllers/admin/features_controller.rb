class Admin::FeaturesController < Flip::FeaturesController
  before_action do
    authorize! :manage, Feature
  end
end
