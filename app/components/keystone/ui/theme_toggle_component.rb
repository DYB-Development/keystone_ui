# frozen_string_literal: true

module Keystone
  module Ui
    class ThemeToggleComponent < ViewComponent::Base
      BUTTON_CLASSES = "ks-theme-toggle ks-button ks-button-sm ks-button-secondary"
      SUN_CLASSES = "size-5 dark:hidden"
      MOON_CLASSES = "size-5 hidden dark:block"
    end
  end
end
