# frozen_string_literal: true

module Keystone
  module Ui
    class RadioCardComponent < ViewComponent::Base
      BASE_CLASSES = "block p-4 rounded-lg border-2 cursor-pointer transition"
      HIGHLIGHT_CLASSES = "border-surface-200 peer-checked:border-accent-500 peer-checked:bg-accent-50"

      attr_reader :name, :value, :label, :hint

      def initialize(name:, value:, label:, hint: nil, checked: false)
        @name = name
        @value = value
        @label = label
        @hint = hint
        @checked = checked
      end

      def checked?
        @checked
      end

      def hint?
        !@hint.nil?
      end

      def classes
        "#{BASE_CLASSES} #{HIGHLIGHT_CLASSES}"
      end
    end
  end
end
