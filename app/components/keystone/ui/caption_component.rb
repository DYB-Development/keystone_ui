# frozen_string_literal: true

module Keystone
  module Ui
    class CaptionComponent < ViewComponent::Base
      TONE_CLASSES = { muted: "ks-caption", link: "ks-caption ks-caption-link" }.freeze
      NORMAL_CASE_CLASSES = "ks-caption-normal-case"

      attr_reader :text

      def initialize(text:, tone: :muted, normal_case: false)
        @normal_case = normal_case
        @text = text
        @tone = tone
      end

      def classes
        [ TONE_CLASSES.fetch(@tone), (NORMAL_CASE_CLASSES if @normal_case) ].compact.join(" ")
      end
    end
  end
end
