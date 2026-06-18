# frozen_string_literal: true

module Keystone
  module Ui
    class PipelineComponent < ViewComponent::Base
      COUNT_BASE_CLASSES = "text-3xl font-bold"
      LINK_BASE_CLASSES = "link-toggle text-2xl leading-none"
      LINK_HEALTHY_CLASSES = "text-accent-500"
      LINK_BROKEN_CLASSES = "text-red-500"

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

      def link_after(index)
        links[index]
      end

      def link_classes(link)
        "#{LINK_BASE_CLASSES} #{link[:broken] ? LINK_BROKEN_CLASSES : LINK_HEALTHY_CLASSES}"
      end
    end
  end
end
