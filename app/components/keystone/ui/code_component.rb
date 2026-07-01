# frozen_string_literal: true

module Keystone
  module Ui
    class CodeComponent < ViewComponent::Base
      attr_reader :language, :caption

      def initialize(language: nil, caption: nil)
        @language = language
        @caption = caption
      end

      def caption?
        !@caption.nil?
      end

      def language_class
        return nil if @language.nil?

        "language-#{@language}"
      end
    end
  end
end
