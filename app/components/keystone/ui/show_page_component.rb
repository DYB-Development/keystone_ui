# frozen_string_literal: true

module Keystone
  module Ui
    class ShowPageComponent < ViewComponent::Base
      DESKTOP_WRAPPER_CLASSES = "hidden md:block"
      TITLE_CLASSES = "ks-page-title text-2xl"
      SUBTITLE_CLASSES = "ks-page-header-subtitle text-sm"

      def initialize(title:, back_url:, subtitle: nil, trail: nil)
        @title = title
        @back_url = back_url
        @subtitle = subtitle
        @trail = trail
      end

      def before_render
        @trail ||= KeystoneUi.configuration.supplied_trail(helpers)
      end

      def subtitle?
        !@subtitle.nil?
      end
    end
  end
end
