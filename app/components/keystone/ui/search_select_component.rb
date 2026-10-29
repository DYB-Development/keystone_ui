# frozen_string_literal: true

module Keystone
  module Ui
    class SearchSelectComponent < ViewComponent::Base
      WRAPPER_CLASSES = "ks-form-field relative"
      LABEL_CLASSES = "ks-label"
      LIST_CLASSES = "ks-menu absolute z-10 w-full hidden"

      attr_reader :name, :label, :url, :selected_id, :selected_label

      def initialize(name:, label:, url:, selected_id: nil, selected_label: nil)
        @name = name
        @label = label
        @url = url
        @selected_id = selected_id
        @selected_label = selected_label
      end
    end
  end
end
