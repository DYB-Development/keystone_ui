# frozen_string_literal: true

module Keystone
  module Ui
    class ActionMenuComponent < ViewComponent::Base
      WRAPPER_CLASSES = "relative inline-block"
      BUTTON_CLASSES = MobileActionsComponent::BUTTON_CLASSES
      DROPDOWN_CLASSES = MobileActionsComponent::DROPDOWN_CLASSES
      ELLIPSIS_ICON = MobileActionsComponent::ELLIPSIS_ICON
    end
  end
end
