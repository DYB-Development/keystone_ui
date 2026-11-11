# frozen_string_literal: true

module Keystone
  module Ui
    class FactsComponent < ViewComponent::Base
      FACTS_CLASSES = "ks-facts flex flex-wrap"
      FACT_CLASSES = "ks-fact"
      VALUE_CLASSES = "ks-tone-neutral"

      attr_reader :facts

      def initialize(facts:)
        @facts = facts
      end

      def facts_classes
        FACTS_CLASSES
      end

      def fact_classes
        FACT_CLASSES
      end

      def value_classes
        VALUE_CLASSES
      end
    end
  end
end
