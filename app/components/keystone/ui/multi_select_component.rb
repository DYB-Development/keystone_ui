# frozen_string_literal: true

module Keystone
  module Ui
    class MultiSelectComponent < ViewComponent::Base
      attr_reader :name, :label, :options, :selected

      def initialize(name:, label:, options:, selected: [])
        @name = name
        @label = label
        @options = options
        @selected = Array(selected).map(&:to_s)
      end

      def display_text
        checked = @selected.reject(&:empty?)
        if checked.empty?
          "All #{@label}"
        else
          "#{checked.length} selected"
        end
      end
    end
  end
end
