# frozen_string_literal: true

module Keystone
  module Ui
    class FormComponent < ViewComponent::Base
      FORM_CLASSES = "ks-form"

      def initialize(action:, method: :post, multipart: false, data: nil, auto_submit: false)
        @action = action
        @method = method.to_sym
        @multipart = multipart
        @data = data
        @auto_submit = auto_submit
      end

      def form_options
        options = {
          url: @action,
          method: @method,
          class: FORM_CLASSES,
          multipart: @multipart
        }
        options[:data] = @data if @data
        options[:data] = (@data || {}).merge(controller: "auto-submit", action: auto_submit_actions) if @auto_submit
        options
      end

      private

      def auto_submit_actions
        [
          "change->auto-submit#changed",
          "input->auto-submit#typed",
          "turbo:before-morph-attribute->auto-submit#keep",
          "turbo:before-render@document->auto-submit#remember",
          "turbo:render@document->auto-submit#restore"
        ].join(" ")
      end
    end
  end
end
