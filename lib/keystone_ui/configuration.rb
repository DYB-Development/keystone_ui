# frozen_string_literal: true

module KeystoneUi
  class Configuration
    attr_accessor :accent, :surface

    def initialize
      @accent = :blue
      @surface = :zinc
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
