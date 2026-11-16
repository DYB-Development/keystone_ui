# frozen_string_literal: true

module Keystone
  module Ui
    class DecisionBarComponent < ViewComponent::Base
      FORM_CLASSES = "flex flex-wrap items-center ks-grid-gap-sm"

      def initialize(url:, primary:, actions: [], note: nil, hint: nil, method: :post)
        @url = url
        @primary = primary
        @actions = actions
        @note = note
        @hint = hint
        @method = method
      end
    end
  end
end
