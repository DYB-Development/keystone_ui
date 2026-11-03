# frozen_string_literal: true

module Keystone
  module Ui
    class MobileActionComponent < ViewComponent::Base
      def call
        link_to("", content_for(:mobile_action_url), aria: { label: content_for(:mobile_action_label) })
      end
    end
  end
end
