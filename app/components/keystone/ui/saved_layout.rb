# frozen_string_literal: true

module Keystone
  module Ui
    class SavedLayout
      def initialize(columns:, value:, default_hidden:)
        @columns = columns
        @value = value.to_h
        @default_hidden = default_hidden
      end

      def columns
        @ordered_columns ||= ordered_columns
      end

      def visible_columns
        columns.reject { |column| hidden?(column.key) }
      end

      def hidden?(key)
        column = @columns.find { |col| col.key == key.to_sym }
        column&.hideable? && hidden_keys.include?(key.to_sym)
      end

      private

      def ordered_columns
        column_order = saved_list("column_order")
        return @columns unless column_order

        positions = Array(column_order).map(&:to_sym).each_with_index.to_h
        hideable = @columns.select(&:hideable?).sort_by.with_index { |col, index| positions.fetch(col.key, positions.size + index) }
        @columns.map { |col| col.hideable? ? hideable.shift : col }
      end

      def hidden_keys
        @hidden_keys ||= Array(saved_list("hidden_columns") || @default_hidden).map(&:to_sym).to_set
      end

      def saved_list(name)
        list = @value[name]
        list if list.is_a?(Array)
      end
    end
  end
end
