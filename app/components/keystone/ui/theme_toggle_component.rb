# frozen_string_literal: true

module Keystone
  module Ui
    class ThemeToggleComponent < ViewComponent::Base
      def initialize(current: nil)
        @current = current
      end

      def pressed?(mode)
        mode == (@current || "system")
      end
    end
  end
end
