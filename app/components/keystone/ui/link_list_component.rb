# frozen_string_literal: true

module Keystone
  module Ui
    class LinkListComponent < ViewComponent::Base
      ROW_CLASSES = "ks-value-list-row items-center no-underline"
      CURRENT_ROW_CLASSES = "ks-value-list-row-current"
      STACK_CLASSES = "flex min-w-0 flex-1 flex-col-reverse ks-grid-gap-sm sm:contents"
      BADGE_CLASSES = "max-sm:self-start"
      TOP_LINE_BADGE_CLASSES = "min-w-0 whitespace-normal"
      TEXT_CLASSES = "min-w-0 flex-1"
      TOP_LINE_CLASSES = "flex items-center justify-between ks-grid-gap-sm whitespace-nowrap"
      TOP_LINE_TEXT_CLASSES = "ks-value-list-note shrink-0 max-w-full truncate"
      LABEL_CLASSES = "ks-paragraph ks-settings-link-label block"
      SUBTITLE_CLASSES = "ks-value-list-note"
      VALUE_CLASSES = "ks-value-list-value shrink-0"

      attr_reader :rows, :chevron

      def initialize(rows:, chevron: true, new_tab: false)
        @rows = rows
        @chevron = chevron
        @new_tab = new_tab
      end

      def row_options(row)
        { class: [ ROW_CLASSES, (CURRENT_ROW_CLASSES if row[:current]) ].compact.join(" "), aria: { current: ("true" if row[:current]) } }.merge(new_tab_options)
      end

      def new_tab_options
        @new_tab ? { target: "_blank", rel: "noopener" } : {}
      end

      def badge(row)
        BadgeComponent.new(**row[:badge], class: BADGE_CLASSES)
      end

      def top_line_badge(row)
        BadgeComponent.new(**row[:top_line][:badge], class: TOP_LINE_BADGE_CLASSES)
      end
    end
  end
end
