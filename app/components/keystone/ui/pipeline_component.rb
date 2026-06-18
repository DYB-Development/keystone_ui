# frozen_string_literal: true

module Keystone
  module Ui
    class PipelineComponent < ViewComponent::Base
      COUNT_BASE_CLASSES = "text-3xl font-bold"

      COUNT_CLASSES = {
        amber: "text-amber-400",
        emerald: "text-accent-400",
        danger: "text-red-400",
        muted: "text-surface-500"
      }.freeze

      attr_reader :title, :boxes, :links, :subtitle

      def initialize(title:, boxes:, links:, subtitle: nil)
        @title = title
        @boxes = boxes
        @links = links
        @subtitle = subtitle
      end

      def count_class(accent)
        "#{COUNT_BASE_CLASSES} #{COUNT_CLASSES.fetch(accent, COUNT_CLASSES[:muted])}"
      end
    end
  end
end
