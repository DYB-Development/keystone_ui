# frozen_string_literal: true

module Keystone
  module Ui
    class PictureComponent < ViewComponent::Base
      def initialize(src:, alt:)
        @src = src
        @alt = alt
      end

      def call
        tag.img(src: @src, alt: @alt)
      end
    end
  end
end
