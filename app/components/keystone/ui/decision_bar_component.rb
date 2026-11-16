# frozen_string_literal: true

module Keystone
  module Ui
    class DecisionBarComponent < ViewComponent::Base
      FORM_CLASSES = "ks-panel ks-panel-radius-md ks-panel-padding-sm flex flex-wrap items-center ks-grid-gap-sm max-sm:contents"
      BAR_CLASSES = "ks-bottom-action max-sm:flex-col ks-grid-gap-sm sm:contents"
      PRIMARY_CLASSES = "max-sm:order-first max-sm:*:w-full max-sm:*:min-h-12"
      HINT_CLASSES = "ks-hint basis-full max-sm:hidden"
      NOTE_CLASSES = "flex flex-1 basis-60 items-center ks-grid-gap-sm max-sm:hidden"

      def initialize(url:, primary:, actions: [], note: nil, hint: nil, method: :post)
        @url = url
        @primary = primary
        @actions = actions
        @note = note
        @hint = hint
        @method = method
      end
    end
  end
end
