# frozen_string_literal: true

module Keystone
  module Ui
    class CodeComponent < ViewComponent::Base
      WRAPPER_CLASSES = "overflow-hidden rounded-lg border border-surface-200 dark:border-surface-700"
      CAPTION_CLASSES = "border-b border-surface-200 bg-surface-50 px-4 py-2 font-mono text-xs text-surface-500 dark:border-surface-700 dark:bg-surface-800 dark:text-surface-400"
      PRE_CLASSES = "overflow-x-auto bg-surface-900 p-4 font-mono text-sm leading-relaxed text-surface-100 dark:bg-black"

      attr_reader :language, :caption

      def initialize(language: nil, caption: nil)
        @language = language
        @caption = caption
      end

      def caption?
        !@caption.nil?
      end

      def wrapper_classes
        WRAPPER_CLASSES
      end

      def caption_classes
        CAPTION_CLASSES
      end

      def pre_classes
        PRE_CLASSES
      end

      def language_class
        return nil if @language.nil?

        "language-#{@language}"
      end
    end
  end
end
