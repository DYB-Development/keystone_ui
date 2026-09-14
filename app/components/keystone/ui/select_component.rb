# frozen_string_literal: true

module Keystone
  module Ui
    class SelectComponent < ViewComponent::Base
      BASE_CLASSES = "ks-input"

      DISABLED_CLASSES = "ks-input-disabled"

      attr_reader :options, :selected, :include_blank

      def initialize(name:, options: [], selected: nil, include_blank: nil, disabled: false)
        @name = name
        @options = options
        @selected = selected
        @include_blank = include_blank
        @disabled = disabled
      end

      def classes
        tokens = [ BASE_CLASSES ]
        tokens << DISABLED_CLASSES if @disabled
        tokens.join(" ")
      end

      def tag_options
        opts = {
          name: @name,
          class: classes
        }
        opts[:disabled] = true if @disabled
        opts
      end
    end
  end
end
