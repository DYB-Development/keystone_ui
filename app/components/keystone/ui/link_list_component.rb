# frozen_string_literal: true

module Keystone
  module Ui
    class LinkListComponent < ViewComponent::Base
      ROW_CLASSES = "ks-value-list-row items-center no-underline"
      STACK_CLASSES = "flex min-w-0 flex-1 flex-col-reverse gap-2 sm:contents"
      BADGE_CLASSES = "max-sm:self-start"
      TEXT_CLASSES = "min-w-0 flex-1"
      LABEL_CLASSES = "ks-paragraph ks-settings-link-label block"
      SUBTITLE_CLASSES = "ks-value-list-note"
      VALUE_CLASSES = "ks-value-list-value shrink-0"

      attr_reader :rows

      def initialize(rows:)
        @rows = rows
      end

      def badge(row)
        BadgeComponent.new(**row[:badge], class: BADGE_CLASSES)
      end
    end
  end
end
