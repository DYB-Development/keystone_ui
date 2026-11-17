# frozen_string_literal: true

module Keystone
  module Ui
    class TextDiffComponent < ViewComponent::Base
      SIDES = %w[before after].freeze
      WRAPPER_CLASSES = "ks-code overflow-hidden"
      COLUMNS_CLASSES = "grid grid-cols-1 sm:grid-cols-2"
      SIDE_CLASSES = "ks-code-block min-w-0 overflow-x-auto font-mono text-sm leading-relaxed"
      ROW_CLASSES = "flex h-[1lh]"
      NUMBER_CLASSES = "w-8 shrink-0 select-none text-right"
      SIGN_CLASSES = "w-6 shrink-0 select-none text-center"
      TEXT_CLASSES = "whitespace-pre"
      LINE_CLASSES = "h-[1lh] whitespace-pre"
      LINE_SIGN_CLASSES = "inline-block w-[2ch] select-none"
      NOTICE_CLASSES = "ks-code-caption text-xs"

      def initialize(before:, after:, one_column: false)
        @before = before.to_s.lines(chomp: true)
        @after = after.to_s.lines(chomp: true)
        @one_column = one_column
      end

      def one_column?
        @one_column
      end

      def notice
        if @before == @after
          "These texts are the same."
        elsif too_long?
          "These texts are too long to compare."
        end
      end

      def too_long?
        @before.size + @after.size > KeystoneUi.configuration.text_diff_line_limit
      end

      def cells(side)
        rows.map { |row| row[SIDES.index(side)] }
      end

      def lines
        return (@before + @after).map { |text| { text: text } } if too_long?

        rows.map { |row| row.compact.first }
      end

      private

      def rows
        @rows ||= too_long? ? side_by_side : compare
      end

      def side_by_side
        Array.new([ @before.size, @after.size ].max) do |index|
          [ @before, @after ].map { |version| { text: version[index], number: index + 1 } if index < version.size }
        end
      end

      def compare
        edits.map do |step, before_index, after_index|
          case step
          when :same then [ { text: @before[before_index], number: before_index + 1 }, { text: @after[after_index], number: after_index + 1 } ]
          when :remove then [ { text: @before[before_index], number: before_index + 1, mark: "ks-diff-removed", sign: "-" }, nil ]
          else [ nil, { text: @after[after_index], number: after_index + 1, mark: "ks-diff-added", sign: "+" } ]
          end
        end
      end

      def edits
        before_index = @before.size
        after_index = @after.size
        steps = []
        furthest_reaches.each_with_index.reverse_each do |reach, changes|
          diagonal = before_index - after_index
          previous_diagonal = added_on?(reach, diagonal, changes) ? diagonal + 1 : diagonal - 1
          previous_before = reach[previous_diagonal]
          previous_after = previous_before - previous_diagonal
          while before_index > previous_before && after_index > previous_after
            before_index -= 1
            after_index -= 1
            steps << [ :same, before_index, after_index ]
          end
          next if changes.zero?

          steps << (before_index == previous_before ? [ :add, nil, after_index - 1 ] : [ :remove, before_index - 1, nil ])
          before_index = previous_before
          after_index = previous_after
        end
        steps.reverse
      end

      def furthest_reaches
        reach = { 1 => 0 }
        (0..(@before.size + @after.size)).each_with_object([]) do |changes, reaches|
          reaches << reach.dup
          (-changes).step(changes, 2) do |diagonal|
            before_index = added_on?(reach, diagonal, changes) ? reach[diagonal + 1] : reach[diagonal - 1] + 1
            after_index = before_index - diagonal
            while before_index < @before.size && after_index < @after.size && @before[before_index] == @after[after_index]
              before_index += 1
              after_index += 1
            end
            reach[diagonal] = before_index
            return reaches if before_index >= @before.size && after_index >= @after.size
          end
        end
      end

      def added_on?(reach, diagonal, changes)
        diagonal == -changes || (diagonal != changes && reach[diagonal - 1] < reach[diagonal + 1])
      end
    end
  end
end
