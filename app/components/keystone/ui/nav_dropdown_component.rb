# frozen_string_literal: true

module Keystone
  module Ui
    class NavDropdownComponent < ViewComponent::Base
      TRIGGER_BASE = "nav-dropdown-trigger"
      CARET_ICON = <<~SVG.freeze
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="nav-dropdown-caret">
          <path fill-rule="evenodd" d="M5.22 8.22a.75.75 0 0 1 1.06 0L10 11.94l3.72-3.72a.75.75 0 1 1 1.06 1.06l-4.25 4.25a.75.75 0 0 1-1.06 0L5.22 9.28a.75.75 0 0 1 0-1.06Z" clip-rule="evenodd" />
        </svg>
      SVG

      attr_reader :title, :area

      def initialize(title:, area:, active: false)
        @title = title
        @area = area
        @active = active
      end

      def trigger_classes
        [TRIGGER_BASE, ("active" if @active)].compact.join(" ")
      end
    end
  end
end
