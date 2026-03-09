# frozen_string_literal: true

module KeystoneUi
  class Configuration
    SUPPORTED_ACCENTS = %i[blue emerald cyan indigo violet rose].freeze

    attr_reader :accent

    def initialize
      @accent = :blue
    end

    def accent=(value)
      value = value.to_sym
      unless SUPPORTED_ACCENTS.include?(value)
        raise ArgumentError, "Unsupported accent: #{value}. Must be one of: #{SUPPORTED_ACCENTS.join(', ')}"
      end

      @accent = value
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
