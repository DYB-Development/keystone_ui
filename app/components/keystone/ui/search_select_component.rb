# frozen_string_literal: true

module Keystone
  module Ui
    class SearchSelectComponent < ViewComponent::Base
      WRAPPER_CLASSES = "ks-form-field relative"
      LABEL_CLASSES = "ks-label"

      attr_reader :name, :label, :url

      def initialize(name:, label:, url:)
        @name = name
        @label = label
        @url = url
      end
    end
  end
end
