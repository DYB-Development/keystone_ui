# frozen_string_literal: true

module KeystoneUi
  class ThemeChoice
    COOKIE = "keystone_theme"
    MODES = %w[light dark system custom].freeze

    def initialize(mode, supplied: nil)
      @mode = mode
      @supplied = supplied
    end

    def html_attributes
      mode == "system" ? {} : { "data-theme" => mode }
    end

    def mode
      [ @mode, @supplied ].find { |candidate| MODES.include?(candidate) } || "light"
    end

    def html_attributes_markup
      html_attributes.map { |name, value| %(#{name}="#{value}") }.join(" ")
    end
  end
end
