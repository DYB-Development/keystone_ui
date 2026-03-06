# frozen_string_literal: true

module Keystone
  module Ui
    class ShowPageComponent < ViewComponent::Base
      def initialize(title:, back_url:, subtitle: nil)
        @title = title
        @back_url = back_url
        @subtitle = subtitle
      end
    end
  end
end
