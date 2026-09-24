# frozen_string_literal: true

module Keystone
  module Ui
    class BucketSeriesComponent < ViewComponent::Base
      ROW_CLASSES = "flex flex-wrap justify-center gap-4 sm:justify-start"

      def initialize(buckets:)
        @buckets = buckets
      end

      def bucket_components
        @buckets.map { |bucket| BucketComponent.new(**bucket) }
      end

      def row_classes
        ROW_CLASSES
      end
    end
  end
end
