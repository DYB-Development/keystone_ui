# frozen_string_literal: true

module Keystone
  module Ui
    class SectionComponent < ViewComponent::Base
      SPACING_CLASSES = { sm: "ks-section-sm", md: "ks-section-md", lg: "ks-section-lg" }.freeze
      HEADER_CLASSES = "ks-section-header"
      HEADER_WITH_ASIDE_CLASSES = "ks-section-header ks-grid-gap-sm max-sm:flex-wrap"
      TITLE_CLASSES = "ks-section-title"
      SUBTITLE_CLASSES = "ks-section-subtitle"
      ACTION_CLASSES = "ks-section-action"
      ACTIONS_CLASSES = "flex items-center shrink-0 ks-grid-gap-sm"
      ASIDE_CLASSES = "ks-heading-note ml-auto wrap-normal max-sm:basis-full max-sm:order-last"

      renders_one :aside

      def initialize(title: nil, subtitle: nil, action: nil, menu: [], spacing: :md, class: nil)
        @title = title
        @subtitle = subtitle
        @action = action
        @menu = menu
        @spacing = spacing
        @extra_classes = binding.local_variable_get(:class)
      end

      def spacing_class
        SPACING_CLASSES.fetch(@spacing)
      end

      def classes
        [ spacing_class, @extra_classes ].compact.join(" ")
      end

      def action_classes
        ACTION_CLASSES
      end

      def header_classes
        aside? ? HEADER_WITH_ASIDE_CLASSES : HEADER_CLASSES
      end

      def header?
        !@title.nil?
      end
    end
  end
end
