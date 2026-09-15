# frozen_string_literal: true

module Keystone
  module Ui
    class CardComponent < ViewComponent::Base
      CARD_CLASSES = "ks-card"
      CARD_EDGE_CLASSES = "ks-card-edge"
      BODY_CLASSES = "ks-card-body"
      CTA_CLASSES = "ks-card-cta"
      TITLE_CLASSES = "ks-card-title"
      SUMMARY_CLASSES = "ks-card-summary"
      LINK_CLASSES = "ks-card-link"

      def initialize(title:, summary:, link:, cta: "Read more", edge_to_edge: false)
        @title = title
        @summary = summary
        @link = link
        @cta = cta
        @edge_to_edge = edge_to_edge
      end

      def link_classes
        LINK_CLASSES
      end

      private

      def card_classes
        @edge_to_edge ? CARD_EDGE_CLASSES : CARD_CLASSES
      end
    end
  end
end
