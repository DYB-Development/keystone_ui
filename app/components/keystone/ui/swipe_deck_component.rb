# frozen_string_literal: true

module Keystone
  module Ui
    class SwipeDeckComponent < ViewComponent::Base
      REJECT_BUTTON_CLASSES = "ks-swipe-button ks-swipe-button-reject flex items-center justify-center size-14 transition-colors"
      ACTIONS_CLASSES = "ks-swipe-actions flex justify-center"
      EMPTY_MESSAGE_CLASSES = "ks-swipe-empty-message"
      EMPTY_TITLE_CLASSES = "ks-swipe-empty-title text-2xl"
      EMPTY_CLASSES = "ks-swipe-empty text-center"
      CARD_CLASSES = "ks-swipe-card absolute inset-0 flex flex-col items-center justify-center transition-transform duration-300"

      STACK_SCALE_STEP = 0.05
      STACK_TRANSLATE_STEP = 8

      def initialize(items:, empty_title: "All done!", empty_subtitle: nil)
        @items = items
        @empty_title = empty_title
        @empty_subtitle = empty_subtitle
        @item_block = nil
      end

      def item(&block)
        @item_block = block
      end

      def before_render
        content
      end

      def card_data
        @items.each_with_index.map do |item, index|
          scale = 1 - (index * STACK_SCALE_STEP)
          translate_y = index * STACK_TRANSLATE_STEP
          {
            item: item,
            index: index,
            z_index: @items.length - index,
            transform: "scale(#{scale}) translateY(#{translate_y}px)"
          }
        end
      end

      def empty?
        @items.empty?
      end

      def item_id(item, fallback_index: nil)
        if item.respond_to?(:id)
          item.id
        else
          fallback_index
        end
      end
    end
  end
end
