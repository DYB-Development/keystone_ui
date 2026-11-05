# frozen_string_literal: true

module Keystone
  module Ui
    class EmptyStateComponent < ViewComponent::Base
      WRAPPER_CLASSES = "flex flex-col items-center gap-2 px-4 py-8 text-center"
      TITLE_CLASSES = "ks-heading-sm"
      MESSAGE_CLASSES = "ks-paragraph ks-tone-muted"

      def initialize(title:, message: nil)
        @title = title
        @message = message
      end
    end
  end
end
