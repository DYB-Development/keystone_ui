# frozen_string_literal: true

module Keystone
  module Ui
    class RadioCardComponent < ViewComponent::Base
      BASE_CLASSES = "ks-radio-card inline-flex flex-col cursor-pointer transition"
      WRAPPER_CLASSES = "inline-block cursor-pointer relative"
      FULL_WIDTH_WRAPPER_CLASSES = "block cursor-pointer relative"
      FULL_WIDTH_CLASSES = "ks-radio-card ks-radio-card-block flex items-start cursor-pointer transition"
      HIGHLIGHT_CLASSES = "ks-radio-card-highlight"
      HEADER_CLASSES = "ks-radio-card-header flex items-start justify-between"
      LABEL_CLASSES = "ks-radio-card-label block"
      HINT_CLASSES = "ks-radio-card-hint block text-sm"
      INFO_BUTTON_CLASSES = "ks-radio-card-info peer shrink-0"
      DISCLOSURE_CLASSES = "ks-radio-card-disclosure hidden peer-hover:block absolute inset-x-0 top-full z-10 text-sm"
      VALUE_CLASSES = "ks-radio-card-value shrink-0"
      INFO_ICON = Keystone::Ui::StatCardComponent::INFO_ICON

      attr_reader :name, :value, :label, :hint, :info

      def initialize(name:, value:, label:, hint: nil, info: nil, checked: false, submits: false, show_value: false, full_width: false)
        @name = name
        @value = value
        @label = label
        @hint = hint
        @info = info
        @checked = checked
        @submits = submits
        @show_value = show_value
        @full_width = full_width
      end

      def show_value?
        @show_value
      end

      def value_classes
        VALUE_CLASSES
      end

      def checked?
        @checked
      end

      def submits?
        @submits
      end

      def hint?
        !@hint.nil?
      end

      def info?
        !@info.nil?
      end

      def info_button_classes
        INFO_BUTTON_CLASSES
      end

      def info_icon
        INFO_ICON
      end

      def disclosure_classes
        DISCLOSURE_CLASSES
      end

      def wrapper_classes
        @full_width ? FULL_WIDTH_WRAPPER_CLASSES : WRAPPER_CLASSES
      end

      def classes
        "#{@full_width ? FULL_WIDTH_CLASSES : BASE_CLASSES} #{HIGHLIGHT_CLASSES}"
      end

      def header_classes
        HEADER_CLASSES
      end

      def label_classes
        LABEL_CLASSES
      end

      def hint_classes
        HINT_CLASSES
      end
    end
  end
end
