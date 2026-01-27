# Allow BigDecimal to be deserialized by Psych (Ruby 3.3 fix for audited)
require "psych"
require "bigdecimal"

Psych.singleton_class.prepend(
  Module.new do
    def safe_load(yaml, **kwargs)
      kwargs[:permitted_classes] ||= []
      kwargs[:permitted_classes] << BigDecimal
      super(yaml, **kwargs)
    end
  end
)
