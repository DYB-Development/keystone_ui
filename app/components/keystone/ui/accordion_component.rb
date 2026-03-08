# frozen_string_literal: true

module Keystone
  module Ui
    class AccordionComponent < ViewComponent::Base
      BASE_CLASSES = "flex flex-col gap-4"

      def initialize; end

      def classes
        BASE_CLASSES
      end
    end
  end
end
