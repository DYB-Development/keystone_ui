# frozen_string_literal: true

module Keystone
  module Ui
    class RadioCardComponent < ViewComponent::Base
      BASE_CLASSES = "ks-radio-card inline-flex flex-col cursor-pointer transition"
      HIGHLIGHT_CLASSES = "ks-radio-card-highlight"
      LABEL_CLASSES = "ks-radio-card-label block"
      HINT_CLASSES = "ks-radio-card-hint block text-sm"
      INFO_BUTTON_CLASSES = "ks-radio-card-info"
      DISCLOSURE_CLASSES = "ks-radio-card-disclosure"
      INFO_ICON = Keystone::Ui::StatCardComponent::INFO_ICON

      attr_reader :name, :value, :label, :hint, :info

      def initialize(name:, value:, label:, hint: nil, info: nil, checked: false)
        @name = name
        @value = value
        @label = label
        @hint = hint
        @info = info
        @checked = checked
      end

      def checked?
        @checked
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

      def classes
        "#{BASE_CLASSES} #{HIGHLIGHT_CLASSES}"
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
