# frozen_string_literal: true

module Keystone
  module Ui
    class FormComponent < ViewComponent::Base
      FORM_CLASSES = "space-y-6"

      def initialize(action:, method: :post, multipart: false, data: nil)
        @action = action
        @method = method.to_sym
        @multipart = multipart
        @data = data
      end

      def form_options
        options = {
          url: @action,
          method: @method,
          class: FORM_CLASSES,
          multipart: @multipart
        }
        options[:data] = @data if @data
        options
      end
    end
  end
end
