# frozen_string_literal: true

module KeystoneUi
  class ThemeChoice
    COOKIE = "keystone_theme"
    MODES = %w[light dark].freeze

    def initialize(mode)
      @mode = mode
    end

    def html_attributes
      return { "data-theme" => "light" } if @mode.nil?

      MODES.include?(@mode) ? { "data-theme" => @mode } : {}
    end

    def html_attributes_markup
      html_attributes.map { |name, value| %(#{name}="#{value}") }.join(" ")
    end
  end
end
