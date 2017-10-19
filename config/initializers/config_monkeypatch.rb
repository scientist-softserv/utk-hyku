# Monkey-patch config gem to support Boolean values in environment variable overrides
# This monkey-patch can be removed once this ticket is fixed & a new version of 'config'
# gem is released: https://github.com/railsconfig/config/issues/178
Config::Options.class_eval do
  protected

    # Try to convert string to a correct type
    # monkey-patch this method to support boolean conversion:
    # https://github.com/railsconfig/config/blob/master/lib/config/options.rb#L190
    def __value(v)
      # rubocop:disable Style/RescueModifier
      __boolean(v) rescue Integer(v) rescue Float(v) rescue v
      # rubocop:enable Style/RescueModifier
    end

    def __boolean(value)
      case value
      when 'false'
        false
      when 'true'
        true
      else
        raise ArgumentError, "invalid value for Boolean(): #{v.inspect}"
      end
    end
end
