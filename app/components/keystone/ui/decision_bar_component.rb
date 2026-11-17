# frozen_string_literal: true

module Keystone
  module Ui
    class DecisionBarComponent < ViewComponent::Base
      FORM_CLASSES = {
        sm: "ks-panel ks-panel-radius-md ks-panel-padding-sm flex flex-wrap items-center ks-grid-gap-sm max-sm:contents",
        md: "ks-panel ks-panel-radius-md ks-panel-padding-sm flex flex-wrap items-center ks-grid-gap-sm max-md:contents",
        lg: "ks-panel ks-panel-radius-md ks-panel-padding-sm flex flex-wrap items-center ks-grid-gap-sm max-lg:contents"
      }.freeze
      BAR_CLASSES = {
        sm: "ks-bottom-action max-sm:flex-col ks-grid-gap-sm sm:contents hotwire-native:bottom-0",
        md: "ks-bottom-action max-md:flex-col ks-grid-gap-sm md:contents hotwire-native:bottom-0",
        lg: "ks-bottom-action max-lg:flex-col ks-grid-gap-sm lg:contents hotwire-native:bottom-0"
      }.freeze
      PRIMARY_CLASSES = "max-sm:order-first max-sm:*:w-full max-sm:*:min-h-12"
      ACTION_CLASSES = "flex *:flex-1"
      PHONE_ONLY_CLASSES = "sm:hidden"
      PHONE_ORDER_CLASSES = { 1 => "max-sm:order-1", 2 => "max-sm:order-2", 3 => "max-sm:order-3" }.freeze
      PHONE_LABEL_CLASSES = "sm:hidden"
      FULL_LABEL_CLASSES = "max-sm:hidden"
      HINT_CLASSES = "ks-hint basis-full max-sm:hidden"
      BAR_COPY_CLASSES = "!static invisible"
      SPACER_CLASSES = "sm:hidden"
      TAB_BAR_ROOM_CLASSES = "hidden h-(--ks-bottom-nav-height) [html:not(.hotwire-native)_body:has(.ks-bottom-nav)_&]:block"
      NOTE_LABEL_CLASSES = "ks-label shrink-0"
      NOTE_CLASSES = "flex flex-1 basis-60 items-center ks-grid-gap-sm max-sm:hidden"

      def initialize(url:, primary:, actions: [], note: nil, hint: nil, method: :post, breakpoint: :sm)
        @breakpoint = breakpoint
        @url = url
        @primary = primary
        @actions = actions
        @note = note
        @hint = hint
        @method = method
      end

      def bar_classes
        BAR_CLASSES.fetch(@breakpoint)
      end

      def form_classes
        FORM_CLASSES.fetch(@breakpoint)
      end

      def buttons
        safe_join([ secondary_row, primary_button ])
      end

      private

      def secondary_row
        render(ButtonRowComponent.new(equal_width: :phone)) do
          safe_join(@actions.map { |action| secondary_button(action) })
        end
      end

      def secondary_button(action)
        tag.div(class: [ ACTION_CLASSES, (PHONE_ONLY_CLASSES if action[:phone_only]), PHONE_ORDER_CLASSES[action[:phone_order]] ].compact.join(" ")) do
          render ButtonComponent.new(variant: :secondary, **action.except(:phone_only, :phone_order, :phone_label), label: action_label(action))
        end
      end

      def action_label(action)
        return action[:label] unless action[:phone_label]

        safe_join([ tag.span(action[:label], class: FULL_LABEL_CLASSES), tag.span(action[:phone_label], class: PHONE_LABEL_CLASSES) ])
      end

      def primary_button
        tag.div(class: PRIMARY_CLASSES) { render ButtonComponent.new(**@primary) }
      end
    end
  end
end
