# frozen_string_literal: true

module Keystone
  module Ui
    class RadioCardComponent < ViewComponent::Base
      BASE_CLASSES = "block p-4 rounded-lg border-2 cursor-pointer transition"

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
        BASE_CLASSES
      end
    end
  end
end
