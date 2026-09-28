# frozen_string_literal: true

module Keystone
  module Ui
    class PipelineComponent < ViewComponent::Base
      CONTAINER_CLASSES = "ks-pipeline"
      HEADER_CLASSES = "ks-pipeline-header"
      TITLE_CLASSES = "ks-pipeline-title text-lg"
      SUBTITLE_CLASSES = "ks-pipeline-subtitle text-sm"
      TRACK_CLASSES = "ks-pipeline-track flex flex-col sm:flex-row sm:items-stretch"
      BOX_CLASSES = "ks-pipeline-box flex flex-1 flex-col items-center text-center"
      BOX_LABEL_CLASSES = "ks-pipeline-box-label text-xs uppercase tracking-wide"
      CONNECTOR_CLASSES = "flex items-center justify-center"
      COUNT_BASE_CLASSES = "ks-pipeline-count text-3xl"
      LINK_BASE_CLASSES = "link-toggle text-2xl leading-none"
      LINK_HEALTHY_CLASSES = "ks-pipeline-link-healthy"
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
