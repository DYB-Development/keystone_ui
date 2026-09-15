# frozen_string_literal: true

module Keystone
  module Ui
    class SectionComponent < ViewComponent::Base
      SPACING_CLASSES = { sm: "ks-section-sm", md: "ks-section-md", lg: "ks-section-lg" }.freeze
      HEADER_CLASSES = "ks-section-header"
      TITLE_CLASSES = "ks-section-title"
      SUBTITLE_CLASSES = "ks-section-subtitle"
      ACTION_CLASSES = "ks-section-action"

      def initialize(title: nil, subtitle: nil, action: nil, spacing: :md, class: nil)
        @title = title
        @subtitle = subtitle
        @action = action
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

      def header?
        !@title.nil?
      end
    end
  end
end
