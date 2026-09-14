# frozen_string_literal: true

module Keystone
  module Ui
    class ThemeToggleComponent < ViewComponent::Base
      def pressed?(mode)
        mode == "system"
      end
    end
  end
end
