# frozen_string_literal: true

module Keystone
  module Ui
    class ColorPickerComponent < ViewComponent::Base
      attr_reader :name, :value

      def initialize(name:, value: "#000000")
        @name = name
        @value = value
      end
    end
  end
end
