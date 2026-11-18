# frozen_string_literal: true

module Keystone
  module Ui
    class ChipRowComponent < ViewComponent::Base
      ROW_CLASSES = "ks-chip-row"
      TONE_CLASSES = States::NAMES.to_h { |state| [ state, "ks-chip ks-chip-#{state}" ] }.freeze

      attr_reader :chips

      def initialize(chips:)
        @chips = chips
      end

      def chip_classes(chip)
        TONE_CLASSES.fetch(chip.fetch(:tone))
      end
    end
  end
end
