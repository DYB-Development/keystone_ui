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

      def initialize(before:, after:)
        @before = before.to_s.lines(chomp: true)
        @after = after.to_s.lines(chomp: true)
      end

      def cells(side)
        rows.map { |row| row[SIDES.index(side)] }
      end

      private

      def rows
        @rows ||= compare
      end

      def compare
        before_index = after_index = 0
        rows = []
        while before_index < @before.size || after_index < @after.size
          if before_index < @before.size && after_index < @after.size && @before[before_index] == @after[after_index]
            rows << [ { text: @before[before_index], number: before_index + 1 }, { text: @after[after_index], number: after_index + 1 } ]
            before_index += 1
            after_index += 1
          elsif before_index < @before.size && (after_index == @after.size || shared[before_index + 1][after_index] >= shared[before_index][after_index + 1])
            rows << [ { text: @before[before_index], number: before_index + 1, mark: "ks-diff-removed", sign: "-" }, nil ]
            before_index += 1
          else
            rows << [ nil, { text: @after[after_index], number: after_index + 1, mark: "ks-diff-added", sign: "+" } ]
            after_index += 1
          end
        end
        rows
      end

      def shared
        @shared ||= begin
          table = Array.new(@before.size + 1) { Array.new(@after.size + 1, 0) }
          (@before.size - 1).downto(0) do |before_index|
            (@after.size - 1).downto(0) do |after_index|
              table[before_index][after_index] = if @before[before_index] == @after[after_index]
                table[before_index + 1][after_index + 1] + 1
              else
                [ table[before_index + 1][after_index], table[before_index][after_index + 1] ].max
              end
            end
          end
          table
        end
      end
    end
  end
end
