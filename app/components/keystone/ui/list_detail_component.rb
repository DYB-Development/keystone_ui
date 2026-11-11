# frozen_string_literal: true

module Keystone
  module Ui
    class ListDetailComponent < ViewComponent::Base
      WRAPPER_CLASSES = "grid grid-cols-1"

      renders_one :detail

      def classes
        WRAPPER_CLASSES
      end
    end
  end
end
