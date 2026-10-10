# frozen_string_literal: true

module Keystone
  module Ui
    class NavigationComponent < ViewComponent::Base
      def groups
        KeystoneUi.configuration.navigation_groups
      end
    end
  end
end
