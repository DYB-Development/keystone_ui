# frozen_string_literal: true

module Keystone
  module Ui
    class CheckboxRowComponent < ViewComponent::Base
      attr_reader :name, :value, :label

      def initialize(name:, value:, label:, checked: false)
        @name = name
        @value = value
        @label = label
        @checked = checked
      end

      def checked?
        @checked
      end
    end
  end
end
