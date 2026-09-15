# frozen_string_literal: true

module Keystone
  module Ui
    class BadgeComponent < ViewComponent::Base
      VARIANT_CLASSES = {
        neutral: "ks-badge-neutral",
        success: "ks-badge-success",
        danger: "ks-badge-danger",
        warning: "ks-badge-warning",
        info: "ks-badge-info"
      }.freeze

      attr_reader :label

      def initialize(label:, variant: :neutral, class: nil)
        @label = label
        @variant = variant
        @extra_classes = binding.local_variable_get(:class)
      end

      def classes
        [ "ks-badge", VARIANT_CLASSES.fetch(@variant), @extra_classes ].compact.join(" ")
      end
    end
  end
end
