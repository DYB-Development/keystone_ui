# frozen_string_literal: true

module Keystone
  module Ui
    class ReviewCardComponent < ViewComponent::Base
      CARD_CLASSES = "ks-card flex flex-col gap-2 p-3.5"
      HEADER_CLASSES = "flex justify-between items-baseline gap-2 text-xs"
      ID_CLASSES = "font-mono ks-tone-muted"

      def initialize(id:, title:)
        @id = id
        @title = title
      end
    end
  end
end
