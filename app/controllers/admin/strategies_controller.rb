class Admin::StrategiesController < Flip::StrategiesController
  before_action do
    authorize! :manage, Feature
  end
end
