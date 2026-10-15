# frozen_string_literal: true

module Keystone
  module Ui
    class ParagraphComponent < ViewComponent::Base
      attr_reader :text

      def initialize(text:)
        @text = text
      end
    end
  end
end
