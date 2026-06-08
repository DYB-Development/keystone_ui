# frozen_string_literal: true

module Keystone
  module Ui
    class RadioCardComponent < ViewComponent::Base
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
        false
      end
    end
  end
end
