# frozen_string_literal: true

module Keystone
  module Ui
    class CalculationComponent < ViewComponent::Base
      Group = Struct.new(:title, :lines, keyword_init: true)
      Line = Struct.new(:label, :working, :result, keyword_init: true)

      TITLE_CLASSES = "ks-label text-sm"
      LINE_CLASSES = "ks-hint text-sm"
      LINES_CLASSES = "grid grid-cols-[auto_1fr_auto] ks-grid-gap-sm"
      RESULT_CLASSES = "ks-hint text-sm text-right"
      GROUPS_CLASSES = "grid ks-grid-gap-md"

      attr_reader :groups, :summary

      def initialize(groups:, summary: "How this is worked out")
        @groups = groups.map { |group| Group.new(title: group[:title], lines: group.fetch(:lines).map { |line| Line.new(**line) }) }
        @summary = summary
      end
    end
  end
end
