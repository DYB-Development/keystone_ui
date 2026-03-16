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

      attr_reader :action

      def form_method
        native_method?(@method) ? @method.to_s : "post"
      end

      def method_override
        native_method?(@method) ? nil : @method.to_s
      end

      def multipart?
        @multipart
      end

      def tag_options
        options = {
          action: @action,
          method: form_method,
          class: FORM_CLASSES
        }
        options[:enctype] = "multipart/form-data" if multipart?
        options[:data] = @data if @data
        options
      end

      private

      def native_method?(method)
        %i[get post].include?(method)
      end
    end
  end
end
