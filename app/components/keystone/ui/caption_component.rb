# frozen_string_literal: true

module Keystone
  module Ui
    class CaptionComponent < ViewComponent::Base
      TONE_CLASSES = { muted: "ks-caption", link: "ks-caption ks-caption-link" }.freeze

      attr_reader :text

      def initialize(text:, tone: :muted)
        @text = text
        @tone = tone
      end

      def classes
        TONE_CLASSES.fetch(@tone)
      end
    end
  end
end
