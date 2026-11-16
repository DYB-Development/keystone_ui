# frozen_string_literal: true

module Keystone
  module Ui
    class ReviewCardComponent < ViewComponent::Base
      CARD_CLASSES = "ks-card flex flex-col gap-2 p-3.5"
      HEADER_CLASSES = "flex justify-between items-baseline gap-2 text-xs"
      ID_CLASSES = "font-mono ks-tone-muted"
      SCORE_CLASSES = "font-medium"
      TITLE_CLASSES = "ks-card-title text-base leading-snug"
      BODY_CLASSES = "ks-card-summary mt-0 text-xs leading-normal"
      CTA_CLASSES = "ks-card-link text-xs"
      META_CLASSES = "ks-card-meta font-mono text-xs ks-tone-muted"
      FINDING_CLASSES = "ks-alert ks-alert-warning px-2 py-1.5 text-xs"
      TONE_CLASSES = { muted: "ks-tone-muted", neutral: "ks-tone-neutral", success: "ks-tone-success", warning: "ks-tone-warning", danger: "ks-tone-danger", info: "ks-tone-info" }.freeze

      def initialize(id:, title:, score: nil, score_tone: :muted, body: nil, cta: nil, meta: nil, finding: nil)
        @id = id
        @title = title
        @score = score
        @score_tone = score_tone
        @body = body
        @cta = cta
        @meta = meta
        @finding = finding
      end

      def score_classes
        [ SCORE_CLASSES, TONE_CLASSES.fetch(@score_tone) ].join(" ")
      end
    end
  end
end
