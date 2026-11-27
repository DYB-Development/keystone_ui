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
        options[:data] = (@data || {}).merge(controller: "auto-submit") if @auto_submit
        options
      end
    end
  end
end
