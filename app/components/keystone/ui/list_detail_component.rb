# frozen_string_literal: true

module Keystone
  module Ui
    class ListDetailComponent < ViewComponent::Base
      WRAPPER_CLASSES = "grid grid-cols-1"
      SPLIT_CLASSES = "lg:grid-cols-3"
      LIST_CLASSES = "lg:order-first"

      renders_one :detail

      def classes
        return WRAPPER_CLASSES unless detail?

        "#{WRAPPER_CLASSES} #{SPLIT_CLASSES}"
      end

      def list_classes
        LIST_CLASSES
      end
    end
  end
end
