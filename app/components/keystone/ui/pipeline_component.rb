# frozen_string_literal: true

module Keystone
  module Ui
    class PipelineComponent < ViewComponent::Base
      attr_reader :title, :boxes, :links, :subtitle

      def initialize(title:, boxes:, links:, subtitle: nil)
        @title = title
        @boxes = boxes
        @links = links
        @subtitle = subtitle
      end
    end
  end
end
