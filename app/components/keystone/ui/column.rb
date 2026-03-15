# frozen_string_literal: true

module Keystone
  module Ui
    class Column
      attr_reader :key, :header_text

      def initialize(key, header_text, mobile_hidden: false, sortable: false)
        @key = key
        @header_text = header_text
        @mobile_hidden = mobile_hidden
        @sortable = sortable
      end

      def mobile_hidden? = @mobile_hidden
      def sortable? = @sortable
    end
  end
end
