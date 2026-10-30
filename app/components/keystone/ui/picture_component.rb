# frozen_string_literal: true

module Keystone
  module Ui
    class PictureComponent < ViewComponent::Base
      IMAGE_CLASSES = "mx-auto max-h-[50svh]"

      def initialize(src:, alt:)
        @src = src
        @alt = alt
      end

      def call
        tag.img(src: @src, alt: @alt, class: IMAGE_CLASSES)
      end
    end
  end
end
