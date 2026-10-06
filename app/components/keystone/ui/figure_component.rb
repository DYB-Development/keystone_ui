# frozen_string_literal: true

module Keystone
  module Ui
    class FigureComponent < ViewComponent::Base
      TONES = {
        neutral: nil,
        success: "ks-tone-success",
        danger: "ks-tone-danger"
      }.freeze

      def initialize(text:, tone: :neutral)
        @text = text
        @tone = tone
      end

      attr_reader :text

      def classes
        [ "ks-figure", TONES.fetch(@tone) ].compact.join(" ")
      end
    end
  end
end
