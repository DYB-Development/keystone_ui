# frozen_string_literal: true

module Keystone
  module Ui
    class ChipRowComponent < ViewComponent::Base
      ROW_CLASSES = "ks-chip-row"
      MONO_VALUE_CLASSES = "font-mono"
      TONE_CLASSES = States::NAMES.to_h { |state| [ state, "ks-chip ks-chip-#{state}" ] }.freeze

      attr_reader :chips

      def initialize(chips:)
        @chips = chips
      end

      def value_classes(chip)
        MONO_VALUE_CLASSES if chip[:mono]
      end

      def chip_classes(chip)
        TONE_CLASSES.fetch(chip.fetch(:tone))
      end
    end
  end
end
