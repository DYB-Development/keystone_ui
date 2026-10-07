# frozen_string_literal: true

module Keystone
  module Ui
    class SavedLayout
      def initialize(columns:, value:, default_hidden:)
        @columns = columns
        @value = value.to_h
        @default_hidden = default_hidden
      end

      def visible_columns
        @columns.reject { |column| hidden?(column.key) }
      end

      def hidden?(key)
        column = @columns.find { |col| col.key == key.to_sym }
        column&.hideable? && hidden_keys.include?(key.to_sym)
      end

      private

      def hidden_keys
        @hidden_keys ||= Array(@value.fetch("hidden_columns", @default_hidden)).map(&:to_sym).to_set
      end
    end
  end
end
