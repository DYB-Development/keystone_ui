# frozen_string_literal: true

module Keystone
  module Ui
    class Column
      attr_reader :key, :header_text

      def initialize(key, header_text, mobile_hidden: false, sortable: false, hideable: false, locked: false)
        @key = key
        @header_text = header_text
        @mobile_hidden = mobile_hidden
        @sortable = sortable
        @hideable = hideable
        @locked = locked
      end

      def mobile_hidden? = @mobile_hidden
      def sortable? = @sortable
      def hideable? = @hideable && !@locked
      def locked? = @locked
    end
  end
end
