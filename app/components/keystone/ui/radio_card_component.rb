# frozen_string_literal: true

module Keystone
  module Ui
    class RadioCardComponent < ViewComponent::Base
      attr_reader :name, :value, :label

      def initialize(name:, value:, label:, hint: nil, checked: false)
        @name = name
        @value = value
        @label = label
        @hint = hint
        @checked = checked
      end

      def checked?
        false
      end
    end
  end
end
