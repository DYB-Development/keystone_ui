# frozen_string_literal: true

module Keystone
  module Ui
    class PictureComponent < ViewComponent::Base
      IMAGE_CLASSES = "mx-auto max-h-[50svh]"

      def initialize(src:, alt:, full_size_url: nil)
        @src = src
        @alt = alt
        @full_size_url = full_size_url
      end

      def call
        image = tag.img(src: @src, alt: @alt, class: IMAGE_CLASSES)
        return image unless @full_size_url

        link_to(image, @full_size_url)
      end
    end
  end
end
