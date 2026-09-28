# frozen_string_literal: true

module Keystone
  module Ui
    class WorkingComponent < ViewComponent::Base
      Group = Struct.new(:title, :lines, keyword_init: true)
      Line = Struct.new(:label, :working, :result, keyword_init: true)

      TITLE_CLASSES = "ks-label text-sm"

      attr_reader :groups, :summary

      def initialize(groups:, summary: "How this is worked out")
        @groups = groups.map { |group| Group.new(title: group[:title], lines: group.fetch(:lines).map { |line| Line.new(**line) }) }
        @summary = summary
      end
    end
  end
end
