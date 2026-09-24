# frozen_string_literal: true

module Keystone
  module Ui
    class BucketSeriesComponent < ViewComponent::Base
      def initialize(buckets:)
        @buckets = buckets
      end

      def bucket_components
        @buckets.map { |bucket| BucketComponent.new(**bucket) }
      end
    end
  end
end
