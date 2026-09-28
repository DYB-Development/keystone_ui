# frozen_string_literal: true

module Keystone
  module Ui
    class WorkingComponent < ViewComponent::Base
      attr_reader :groups, :summary

      def initialize(groups:, summary: "How this is worked out")
        @groups = groups
        @summary = summary
      end
    end
  end
end
