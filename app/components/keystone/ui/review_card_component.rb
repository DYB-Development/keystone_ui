# frozen_string_literal: true

module Keystone
  module Ui
    class ReviewCardComponent < ViewComponent::Base
      CARD_CLASSES = "ks-card ks-panel-padding-sm flex flex-col ks-grid-gap-sm sm:[&_.ks-button]:min-w-0 sm:[&_.ks-button]:text-xs"
      WARNING_CLASSES = "ks-card-warning"
      HEADER_CLASSES = "flex justify-between items-baseline ks-grid-gap-sm text-xs"
      ID_CLASSES = "font-mono ks-tone-muted"
      TITLE_CLASSES = "ks-card-title text-base leading-snug"
      BODY_CLASSES = "ks-card-summary mt-0 text-xs leading-normal"
      COMPACT_BODY_CLASSES = "truncate"
      CTA_CLASSES = "ks-card-link text-xs"
      META_CLASSES = "ks-card-meta font-mono text-xs ks-tone-muted"
      FINDING_CLASSES = "ks-alert ks-alert-warning text-xs"
      TONE_CLASSES = { muted: "ks-tone-muted", neutral: "ks-tone-neutral", success: "ks-tone-success", warning: "ks-tone-warning", danger: "ks-tone-danger", info: "ks-tone-info" }.freeze

      def initialize(id:, title:, score: nil, score_tone: :muted, body: nil, cta: nil, meta: nil, finding: nil, actions: [], compact: false)
        @id = id
        @title = title
        @score = score
        @score_tone = score_tone
        @body = body
        @cta = cta
        @meta = meta
        @finding = finding
        @actions = actions
        @compact = compact
      end

      def action_row
        render(ButtonRowComponent.new(equal_width: true)) do
          safe_join(@actions.map { |action| render ButtonComponent.new(variant: :secondary, size: :sm, **action) })
        end
      end

      def card_classes
        [ CARD_CLASSES, (WARNING_CLASSES if @finding) ].compact.join(" ")
      end

      def body_classes
        [ BODY_CLASSES, (COMPACT_BODY_CLASSES if @compact) ].compact.join(" ")
      end

      def score_classes
        TONE_CLASSES.fetch(@score_tone)
      end
    end
  end
end
