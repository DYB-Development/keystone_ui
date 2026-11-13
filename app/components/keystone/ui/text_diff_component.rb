# frozen_string_literal: true

module Keystone
  module Ui
    class TextDiffComponent < ViewComponent::Base
      SIDES = %w[before after].freeze

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
            rows << [ { text: @before[before_index] }, { text: @after[after_index] } ]
            before_index += 1
            after_index += 1
          elsif before_index < @before.size && (after_index == @after.size || shared[before_index + 1][after_index] >= shared[before_index][after_index + 1])
            rows << [ { text: @before[before_index], mark: "ks-diff-removed" }, nil ]
            before_index += 1
          else
            rows << [ nil, { text: @after[after_index] } ]
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
