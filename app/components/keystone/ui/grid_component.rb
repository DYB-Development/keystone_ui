# frozen_string_literal: true

module Keystone
  module Ui
    class GridComponent < ViewComponent::Base
      GAP_CLASSES = { sm: "ks-grid-gap-sm", md: "ks-grid-gap-md", lg: "ks-grid-gap-lg", xl: "ks-grid-gap-xl" }.freeze
      GAP_X_CLASSES = { sm: "ks-grid-gap-x-sm", md: "ks-grid-gap-x-md", lg: "ks-grid-gap-x-lg", xl: "ks-grid-gap-x-xl" }.freeze
      GAP_Y_CLASSES = { sm: "ks-grid-gap-y-sm", md: "ks-grid-gap-y-md", lg: "ks-grid-gap-y-lg", xl: "ks-grid-gap-y-xl" }.freeze
      COL_CLASSES = {
        default: { 1 => "grid-cols-1", 2 => "grid-cols-2", 3 => "grid-cols-3", 4 => "grid-cols-4", 5 => "grid-cols-5", 6 => "grid-cols-6", 7 => "grid-cols-7", 8 => "grid-cols-8", 9 => "grid-cols-9", 10 => "grid-cols-10", 11 => "grid-cols-11", 12 => "grid-cols-12" }.freeze,
        sm: { 1 => "sm:grid-cols-1", 2 => "sm:grid-cols-2", 3 => "sm:grid-cols-3", 4 => "sm:grid-cols-4", 5 => "sm:grid-cols-5", 6 => "sm:grid-cols-6", 7 => "sm:grid-cols-7", 8 => "sm:grid-cols-8", 9 => "sm:grid-cols-9", 10 => "sm:grid-cols-10", 11 => "sm:grid-cols-11", 12 => "sm:grid-cols-12" }.freeze,
        md: { 1 => "md:grid-cols-1", 2 => "md:grid-cols-2", 3 => "md:grid-cols-3", 4 => "md:grid-cols-4", 5 => "md:grid-cols-5", 6 => "md:grid-cols-6", 7 => "md:grid-cols-7", 8 => "md:grid-cols-8", 9 => "md:grid-cols-9", 10 => "md:grid-cols-10", 11 => "md:grid-cols-11", 12 => "md:grid-cols-12" }.freeze,
        lg: { 1 => "lg:grid-cols-1", 2 => "lg:grid-cols-2", 3 => "lg:grid-cols-3", 4 => "lg:grid-cols-4", 5 => "lg:grid-cols-5", 6 => "lg:grid-cols-6", 7 => "lg:grid-cols-7", 8 => "lg:grid-cols-8", 9 => "lg:grid-cols-9", 10 => "lg:grid-cols-10", 11 => "lg:grid-cols-11", 12 => "lg:grid-cols-12" }.freeze,
        xl: { 1 => "xl:grid-cols-1", 2 => "xl:grid-cols-2", 3 => "xl:grid-cols-3", 4 => "xl:grid-cols-4", 5 => "xl:grid-cols-5", 6 => "xl:grid-cols-6", 7 => "xl:grid-cols-7", 8 => "xl:grid-cols-8", 9 => "xl:grid-cols-9", 10 => "xl:grid-cols-10", 11 => "xl:grid-cols-11", 12 => "xl:grid-cols-12" }.freeze
      }.freeze

      WIDE_COL_CLASSES = {
        first: { default: "grid-cols-[minmax(0,3fr)_minmax(0,2fr)]", sm: "sm:grid-cols-[minmax(0,3fr)_minmax(0,2fr)]", md: "md:grid-cols-[minmax(0,3fr)_minmax(0,2fr)]", lg: "lg:grid-cols-[minmax(0,3fr)_minmax(0,2fr)]", xl: "xl:grid-cols-[minmax(0,3fr)_minmax(0,2fr)]" }.freeze,
        second: { default: "grid-cols-[minmax(0,2fr)_minmax(0,3fr)]", sm: "sm:grid-cols-[minmax(0,2fr)_minmax(0,3fr)]", md: "md:grid-cols-[minmax(0,2fr)_minmax(0,3fr)]", lg: "lg:grid-cols-[minmax(0,2fr)_minmax(0,3fr)]", xl: "xl:grid-cols-[minmax(0,2fr)_minmax(0,3fr)]" }.freeze
      }.freeze

      def initialize(cols: { default: 1 }, gap: :md, gap_x: nil, gap_y: nil, wide: nil)
        @wide = wide
        @cols = cols
        @gap = gap
        @gap_x = gap_x
        @gap_y = gap_y
      end

      def classes
        tokens = [ "grid" ]
        if @gap_x || @gap_y
          tokens << GAP_X_CLASSES.fetch(@gap_x) if @gap_x
          tokens << GAP_Y_CLASSES.fetch(@gap_y) if @gap_y
        else
          tokens << GAP_CLASSES.fetch(@gap)
        end
        @cols.each do |breakpoint, count|
          tokens << col_class(breakpoint, count)
        end
        tokens.join(" ")
      end

      private

      def col_class(breakpoint, count)
        return WIDE_COL_CLASSES.fetch(@wide).fetch(breakpoint) if @wide && count == 2

        COL_CLASSES.fetch(breakpoint).fetch(count)
      end
    end
  end
end
