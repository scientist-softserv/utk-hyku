Config.setup do |config|
  # Name of the constat exposing loaded settings
  config.const_name = 'Settings'

  config.use_env = true

  # Ability to remove elements of the array set in earlier loaded settings file. Default: nil
  # config.knockout_prefix = '--'
end
