# frozen_string_literal: true

module Keystone
  module Ui
    class CheckboxRowComponent < ViewComponent::Base
      attr_reader :name, :value, :label

      def initialize(name:, value:, label:)
        @name = name
        @value = value
        @label = label
      end
    end
  end
end
