# frozen_string_literal: true

module KeystoneUi
  class ThemeChoice
    COOKIE = "keystone_theme"
    MODES = %w[light dark system].freeze

    def initialize(mode)
      @mode = mode
    end

    def html_attributes
      mode == "system" ? {} : { "data-theme" => mode }
    end

    def mode
      MODES.include?(@mode) ? @mode : "light"
    end

    def html_attributes_markup
      html_attributes.map { |name, value| %(#{name}="#{value}") }.join(" ")
    end
  end
end
