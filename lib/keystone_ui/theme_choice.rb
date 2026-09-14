# frozen_string_literal: true

module KeystoneUi
  class ThemeChoice
    COOKIE = "keystone_theme"
    MODES = %w[light dark].freeze

    def initialize(mode)
      @mode = mode
    end

    def html_attributes
      MODES.include?(@mode) ? { "data-theme" => @mode } : {}
    end
  end
end
