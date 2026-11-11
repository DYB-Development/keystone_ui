# frozen_string_literal: true

module Keystone
  module Ui
    class ListDetailComponent < ViewComponent::Base
      WRAPPER_CLASSES = "grid grid-cols-1"
      SPLIT_CLASSES = "lg:grid-cols-3"

      renders_one :detail

      def classes
        return WRAPPER_CLASSES unless detail?

        "#{WRAPPER_CLASSES} #{SPLIT_CLASSES}"
      end
    end
  end
end
