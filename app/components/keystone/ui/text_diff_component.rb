# frozen_string_literal: true

module Keystone
  module Ui
    class TextDiffComponent < ViewComponent::Base
      def initialize(before:, after:)
        @before = before.to_s.lines(chomp: true)
        @after = after.to_s.lines(chomp: true)
      end

      def sides
        { "before" => @before, "after" => @after }
      end
    end
  end
end
