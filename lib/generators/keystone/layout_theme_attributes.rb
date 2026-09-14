# frozen_string_literal: true

module Keystone
  class LayoutThemeAttributes
    HELPER_CALL = "<%= keystone_theme_attributes %>"

    def initialize(layout)
      @layout = layout
    end

    def apply
      return @layout if @layout.include?(HELPER_CALL)

      @layout.sub(/<html\b/, "<html #{HELPER_CALL}")
    end
  end
end
