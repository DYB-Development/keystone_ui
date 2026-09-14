# frozen_string_literal: true

module KeystoneUi
  class ThemeChoice
    def initialize(mode)
      @mode = mode
    end

    def html_attributes
      { "data-theme" => @mode }
    end
  end
end
