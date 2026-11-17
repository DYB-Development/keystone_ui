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
      PRIMARY_CLASSES = {
        sm: "max-sm:order-first max-sm:*:w-full max-sm:*:min-h-12",
        md: "max-md:order-first max-md:*:w-full max-md:*:min-h-12",
        lg: "max-lg:order-first max-lg:*:w-full max-lg:*:min-h-12"
      }.freeze
      ACTION_CLASSES = "flex *:flex-1 *:min-w-0"
      SECONDARY_ROW_CLASSES = {
        sm: "max-sm:*:flex-1 max-sm:*:min-w-0",
        md: "max-md:*:flex-1 max-md:*:min-w-0",
        lg: "max-lg:*:flex-1 max-lg:*:min-w-0"
      }.freeze
      PHONE_ONLY_CLASSES = {
        sm: "sm:hidden",
        md: "md:hidden",
        lg: "lg:hidden"
      }.freeze
      PHONE_ORDER_CLASSES = {
        sm: { 1 => "max-sm:order-1", 2 => "max-sm:order-2", 3 => "max-sm:order-3" }.freeze,
        md: { 1 => "max-md:order-1", 2 => "max-md:order-2", 3 => "max-md:order-3" }.freeze,
        lg: { 1 => "max-lg:order-1", 2 => "max-lg:order-2", 3 => "max-lg:order-3" }.freeze
      }.freeze
      PHONE_LABEL_CLASSES = {
        sm: "sm:hidden",
        md: "md:hidden",
        lg: "lg:hidden"
      }.freeze
      FULL_LABEL_CLASSES = {
        sm: "max-sm:hidden",
        md: "max-md:hidden",
        lg: "max-lg:hidden"
      }.freeze
      HINT_CLASSES = {
        sm: "ks-hint basis-full max-sm:hidden",
        md: "ks-hint basis-full max-md:hidden",
        lg: "ks-hint basis-full max-lg:hidden"
      }.freeze
      BAR_COPY_CLASSES = "!static invisible"
      SPACER_CLASSES = {
        sm: "sm:hidden",
        md: "md:hidden",
        lg: "lg:hidden"
      }.freeze
      TAB_BAR_ROOM_CLASSES = "hidden h-(--ks-bottom-nav-height) [html:not(.hotwire-native)_body:has(.ks-bottom-nav)_&]:block"
      NOTE_LABEL_CLASSES = "ks-label shrink-0"
      NOTE_CLASSES = {
        sm: "flex flex-1 basis-60 items-center ks-grid-gap-sm max-sm:hidden",
        md: "flex flex-1 basis-60 items-center ks-grid-gap-sm max-md:hidden",
        lg: "flex flex-1 basis-60 items-center ks-grid-gap-sm max-lg:hidden"
      }.freeze

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

      def note_classes
        NOTE_CLASSES.fetch(@breakpoint)
      end

      def hint_classes
        HINT_CLASSES.fetch(@breakpoint)
      end

      def spacer_classes
        SPACER_CLASSES.fetch(@breakpoint)
      end

      def buttons
        safe_join([ secondary_row, primary_button ])
      end

      private

      def secondary_row
        render(ButtonRowComponent.new(class: SECONDARY_ROW_CLASSES.fetch(@breakpoint))) do
          safe_join(@actions.map { |action| secondary_button(action) })
        end
      end

      def secondary_button(action)
        tag.div(class: [ ACTION_CLASSES, (PHONE_ONLY_CLASSES.fetch(@breakpoint) if action[:phone_only]), PHONE_ORDER_CLASSES.fetch(@breakpoint)[action[:phone_order]] ].compact.join(" ")) do
          render ButtonComponent.new(variant: :secondary, **action.except(:phone_only, :phone_order, :phone_label), label: action_label(action))
        end
      end

      def action_label(action)
        return action[:label] unless action[:phone_label]

        safe_join([ tag.span(action[:label], class: FULL_LABEL_CLASSES.fetch(@breakpoint)), tag.span(action[:phone_label], class: PHONE_LABEL_CLASSES.fetch(@breakpoint)) ])
      end

      def primary_button
        tag.div(class: PRIMARY_CLASSES.fetch(@breakpoint)) { render ButtonComponent.new(**@primary) }
      end
    end
  end
end
