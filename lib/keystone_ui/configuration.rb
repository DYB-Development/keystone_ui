# frozen_string_literal: true

module KeystoneUi
  class Configuration
    attr_accessor :accent, :surface, :theme_mode_supplier
    attr_reader :tailwind_imports, :tailwind_sources

    def initialize
      @accent = :blue
      @surface = :zinc
      @tailwind_imports = []
      @tailwind_sources = []
    end

    def supplied_theme_mode(view)
      theme_mode_supplier&.call(view)
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
