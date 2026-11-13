# frozen_string_literal: true

module Keystone
  module Ui
    class BottomActionComponent < ViewComponent::Base
      BAR_CLASSES = "ks-bottom-action"

      def call
        tag.div(class: BAR_CLASSES) do
          render ButtonComponent.new(label: content_for(:mobile_action_label), href: content_for(:mobile_action_url), full_width: true)
        end
      end
    end
  end
end
