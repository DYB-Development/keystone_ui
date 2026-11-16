# frozen_string_literal: true

module Keystone
  module Ui
    class ReviewCardGridComponent < ViewComponent::Base
      COLUMNS = { default: 1, lg: 3 }.freeze

      def call
        render(GridComponent.new(cols: COLUMNS, gap: :sm)) { content }
      end
    end
  end
end
