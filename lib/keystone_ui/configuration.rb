# frozen_string_literal: true

module KeystoneUi
  class Configuration
    SUPPORTED_ACCENTS = %i[blue emerald cyan indigo violet rose].freeze
    SUPPORTED_SURFACES = %i[zinc slate gray neutral stone].freeze
    REQUIRED_ACCENT_KEYS = %i[border bg text dark_text hover_border dark_hover_border hover_text dark_hover_text].freeze

    attr_reader :accent, :surface

    def initialize
      @accent = :blue
      @surface = :zinc
    end

    def accent=(value)
      if value.is_a?(Hash)
        value = value.transform_keys(&:to_sym)
        missing = REQUIRED_ACCENT_KEYS - value.keys
        if missing.any?
          raise ArgumentError, "Custom accent missing required keys: #{missing.join(', ')}"
        end
        @accent = value
      else
        value = value.to_sym
        unless SUPPORTED_ACCENTS.include?(value)
          raise ArgumentError, "Unsupported accent: #{value}. Must be one of: #{SUPPORTED_ACCENTS.join(', ')}"
        end
        @accent = value
      end
    end

    def surface=(value)
      value = value.to_sym
      unless SUPPORTED_SURFACES.include?(value)
        raise ArgumentError, "Unsupported surface: #{value}. Must be one of: #{SUPPORTED_SURFACES.join(', ')}"
      end

      @surface = value
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.reset_configuration!
    @configuration = Configuration.new
  end
end
