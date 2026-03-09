# frozen_string_literal: true

module KeystoneUi
  class Configuration
    SUPPORTED_ACCENTS = %i[blue emerald cyan indigo violet rose].freeze
    SUPPORTED_SURFACES = %i[zinc slate gray neutral stone].freeze

    attr_reader :accent, :surface

    def initialize
      @accent = :blue
      @surface = :zinc
    end

    def accent=(value)
      value = value.to_sym
      unless SUPPORTED_ACCENTS.include?(value)
        raise ArgumentError, "Unsupported accent: #{value}. Must be one of: #{SUPPORTED_ACCENTS.join(', ')}"
      end

      @accent = value
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
