# frozen_string_literal: true

module Keystone
  module Ui
    class DecisionBarComponent < ViewComponent::Base
      FORM_CLASSES = "ks-panel ks-panel-radius-md ks-panel-padding-sm flex flex-wrap items-center ks-grid-gap-sm max-sm:contents"
      BAR_CLASSES = "ks-bottom-action max-sm:flex-col ks-grid-gap-sm sm:contents"
      PRIMARY_CLASSES = "max-sm:order-first max-sm:*:w-full max-sm:*:min-h-12"
      HINT_CLASSES = "ks-hint basis-full max-sm:hidden"
      BAR_COPY_CLASSES = "!static invisible"
      SPACER_CLASSES = "sm:hidden"
      TAB_BAR_ROOM_CLASSES = "hidden h-(--ks-bottom-nav-height) [body:has(.ks-bottom-nav)_&]:block"
      NOTE_CLASSES = "flex flex-1 basis-60 items-center ks-grid-gap-sm max-sm:hidden"

      def initialize(url:, primary:, actions: [], note: nil, hint: nil, method: :post)
        @url = url
        @primary = primary
        @actions = actions
        @note = note
        @hint = hint
        @method = method
      end

      def buttons
        safe_join([ secondary_row, primary_button ])
      end

      private

      def secondary_row
        render(ButtonRowComponent.new(equal_width: :phone)) do
          safe_join(@actions.map { |action| render ButtonComponent.new(variant: :secondary, **action) })
        end
      end

      def primary_button
        tag.div(class: PRIMARY_CLASSES) { render ButtonComponent.new(**@primary) }
      end
    end
  end
end
