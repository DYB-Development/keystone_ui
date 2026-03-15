# frozen_string_literal: true

module Keystone
  module Ui
    class DataTableComponent < ViewComponent::Base
      HEADER_CLASSES_FIRST = "py-3.5 pr-3 pl-6 text-left text-sm font-semibold text-gray-900 dark:text-gray-200"
      HEADER_CLASSES_MIDDLE = "px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-200"
      HEADER_CLASSES_LAST = "py-3.5 pr-6 pl-3"

      ROW_CLASSES_FIRST = "py-4 pr-3 pl-6 text-sm font-medium whitespace-nowrap text-gray-900 dark:text-white"
      ROW_CLASSES_MIDDLE = "px-3 py-4 text-sm whitespace-nowrap text-gray-500 dark:text-gray-400"
      ROW_CLASSES_LAST = "py-4 pr-6 pl-3 text-right text-sm font-medium whitespace-nowrap"

      MOBILE_HIDDEN_CLASSES = "hidden sm:table-cell"

      SORT_LINK_CLASSES = "group inline-flex items-center gap-1"
      SORT_ICON_CLASSES = "h-4 w-4 flex-shrink-0"
      SORT_ICON_ACTIVE = "text-gray-700 dark:text-gray-300"
      SORT_ICON_INACTIVE = "text-gray-400 dark:text-gray-500 invisible group-hover:visible"

      SORT_ASC_ICON = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M10 17a.75.75 0 0 1-.75-.75V5.612L5.29 9.77a.75.75 0 0 1-1.08-1.04l5.25-5.5a.75.75 0 0 1 1.08 0l5.25 5.5a.75.75 0 1 1-1.08 1.04l-3.96-4.158V16.25A.75.75 0 0 1 10 17Z" clip-rule="evenodd" /></svg>'
      SORT_DESC_ICON = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M10 3a.75.75 0 0 1 .75.75v10.638l3.96-4.158a.75.75 0 1 1 1.08 1.04l-5.25 5.5a.75.75 0 0 1-1.08 0l-5.25-5.5a.75.75 0 0 1 1.08-1.04l3.96 4.158V3.75A.75.75 0 0 1 10 3Z" clip-rule="evenodd" /></svg>'
      SORT_NEUTRAL_ICON = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M10 3a.75.75 0 0 1 .55.24l3.25 3.5a.75.75 0 1 1-1.1 1.02L10 4.852 7.3 7.76a.75.75 0 0 1-1.1-1.02l3.25-3.5A.75.75 0 0 1 10 3Zm-3.76 9.2a.75.75 0 0 1 1.06.04l2.7 2.908 2.7-2.908a.75.75 0 1 1 1.1 1.02l-3.25 3.5a.75.75 0 0 1-1.1 0l-3.25-3.5a.75.75 0 0 1 .04-1.06Z" clip-rule="evenodd" /></svg>'

      def initialize(items:, columns:, empty_message: nil, sort: nil, sort_direction: nil, sort_url: nil)
        @items = items
        @columns = columns.map { |col| normalize_column(col) }
        @empty_message = empty_message
        @sort = sort&.to_sym
        @sort_direction = sort_direction&.to_sym
        @sort_url = sort_url
        @actions_block = nil
        @link_blocks = {}
      end

      def before_render
        content
      end

      def link(column_key, &block)
        @link_blocks[column_key] = block
      end

      def actions(&block)
        @actions_block = block
      end

      def actions?
        !!@actions_block
      end

      def column_keys
        @column_keys ||= @columns.map(&:key)
      end

      def column_labels
        @column_labels ||= @columns.map(&:header_text)
      end

      def header_cells
        cells = @columns.map.with_index do |column, index|
          tokens = [header_classes_for(index)]
          tokens << MOBILE_HIDDEN_CLASSES if column.mobile_hidden?

          cell = {
            label: column.header_text,
            classes: tokens.join(" "),
            scope: "col"
          }

          if @sort_url
            active = column.sortable? && @sort == column.key
            cell[:sortable] = column.sortable?

            if column.sortable?
              if active
                cell[:sort_active] = true
                cell[:sort_direction] = @sort_direction
                next_dir = @sort_direction == :asc ? :desc : :asc
              else
                cell[:sort_active] = false
                next_dir = :asc
              end
              cell[:sort_href] = @sort_url.call(column.key, next_dir)
            end
          end

          cell
        end

        if actions?
          cells << {
            label: "Actions",
            classes: HEADER_CLASSES_LAST,
            scope: "col"
          }
        end

        cells
      end

      def row_cells
        @row_cells ||= @items.map do |item|
          @columns.map.with_index do |column, index|
            tokens = [row_classes_for(index)]
            tokens << MOBILE_HIDDEN_CLASSES if column.mobile_hidden?

            cell = {
              value: resolve_value(item, column.key),
              classes: tokens.join(" ")
            }

            link_block = @link_blocks[column.key]
            cell[:href] = link_block.call(item) if link_block

            cell
          end
        end
      end

      def empty?
        @items.empty?
      end

      def column_count
        visual_column_count
      end

      private

      def visual_column_count
        @columns.length + (actions? ? 1 : 0)
      end

      def normalize_column(col)
        case col
        when Column then col
        when Hash
          key, label = col.first
          Column.new(key, label)
        end
      end

      def resolve_value(item, key)
        if item.respond_to?(key)
          item.public_send(key)
        else
          item[key]
        end
      end

      def header_classes_for(index)
        last_data_index = @columns.length - 1

        return HEADER_CLASSES_FIRST if index.zero?
        return HEADER_CLASSES_LAST if index == last_data_index && !actions?

        HEADER_CLASSES_MIDDLE
      end

      def row_classes_for(index)
        last_data_index = @columns.length - 1

        return ROW_CLASSES_FIRST if index.zero?
        return ROW_CLASSES_LAST if index == last_data_index && !actions?

        ROW_CLASSES_MIDDLE
      end
    end
  end
end
