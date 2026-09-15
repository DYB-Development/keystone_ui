# frozen_string_literal: true

module Keystone
  module Ui
    class AlertComponent < ViewComponent::Base
      TYPE_CLASSES = {
        info: "ks-alert-info",
        success: "ks-alert-success",
        warning: "ks-alert-warning",
        error: "ks-alert-error"
      }.freeze

      OUTER_CLASSES = "ks-alert-body"
      INNER_CLASSES = "ks-alert-content"
      TITLE_CLASSES = "ks-alert-title"
      MESSAGE_CLASSES = "ks-alert-message"
      MESSAGE_WITH_TITLE_CLASSES = "ks-alert-message-titled"
      DISMISS_CLASSES = "ks-alert-dismiss"

      def initialize(message:, type: :info, title: nil, dismissible: false)
        @message = message
        @type = type
        @title = title
        @dismissible = dismissible
      end

      def classes
        "ks-alert #{TYPE_CLASSES.fetch(@type)}"
      end

      def message_text
        @message
      end

      def title?
        !@title.nil?
      end

      def title_text
        @title
      end

      def dismissible?
        @dismissible
      end

      def wrapper_data
        dismissible? ? { controller: "dismiss" } : {}
      end
    end
  end
end
