# frozen_string_literal: true

require "minitest/autorun"

unless defined?(ViewComponent)
  module ViewComponent
    class Base
      def content
        @__content_block&.call(self)
      end

      def set_content_block(&block)
        @__content_block = block
      end

      def self.renders_one(name, **_opts)
        @registered_slots ||= {}
        @registered_slots[name] = :one
        define_method(:"#{name}?") { false }
      end

      def self.renders_many(name, **_opts)
        @registered_slots ||= {}
        @registered_slots[name] = :many
      end

      def self.registered_slots
        @registered_slots || {}
      end
    end
  end
end

require_relative "../lib/keystone_ui/configuration"
require_relative "../app/components/keystone/ui/card_component"
require_relative "../app/components/keystone/ui/button_component"
require_relative "../app/components/keystone/ui/data_table_component"
require_relative "../app/components/keystone/ui/page_component"
require_relative "../app/components/keystone/ui/section_component"
require_relative "../app/components/keystone/ui/grid_component"
require_relative "../app/components/keystone/ui/panel_component"
require_relative "../app/components/keystone/ui/card_link_component"
require_relative "../app/components/keystone/ui/input_component"
require_relative "../app/components/keystone/ui/textarea_component"
require_relative "../app/components/keystone/ui/form_field_component"
require_relative "../app/components/keystone/ui/page_header_component"
require_relative "../app/components/keystone/ui/alert_component"
require_relative "../app/components/keystone/ui/nav_item_component"
require_relative "../app/components/keystone/ui/bottom_nav_item_component"
require_relative "../app/components/keystone/ui/navbar_component"
require_relative "../app/components/keystone/ui/bottom_nav_component"
require_relative "../app/components/keystone/ui/settings_link_component"
require_relative "../app/components/keystone/ui/nav_dropdown_component"
require_relative "../app/components/keystone/ui/form_page_component"
require_relative "../app/components/keystone/ui/mobile_actions_component"
require_relative "../app/components/keystone/ui/mobile_header_component"
require_relative "../app/components/keystone/ui/show_page_component"
require_relative "../app/components/keystone/ui/accordion_component"
require_relative "../app/components/keystone/ui/tab_switcher_component"
require_relative "../app/components/keystone/ui/stat_card_component"
require_relative "../app/components/keystone/ui/chart_card_component"
require_relative "../app/components/keystone/ui/line_chart_component"
require_relative "../app/components/keystone/ui/cta_banner_component"
require_relative "../app/components/keystone/ui/feature_grid_component"
require_relative "../app/components/keystone/ui/hero_component"
require_relative "../app/components/keystone/ui/modal_component"
require_relative "../app/components/keystone/ui/select_component"
require_relative "../app/components/keystone/ui/badge_component"
require_relative "../app/components/keystone/ui/copy_button_component"
require_relative "../app/components/keystone/ui/option_card_component"
require_relative "../app/components/keystone/ui/radio_card_component"
require_relative "../app/components/keystone/ui/progress_component"
require_relative "../app/components/keystone/ui/color_picker_component"
require_relative "../app/components/keystone/ui/multi_select_component"
require_relative "../app/components/keystone/ui/swipe_deck_component"
require_relative "../app/components/keystone/ui/column_picker_component"
require_relative "../app/components/keystone/ui/form_component"
require_relative "../app/components/keystone/ui/file_upload_component"
require_relative "../app/components/keystone/ui/funnel_component"
require_relative "../app/components/keystone/ui/pipeline_component"
require_relative "../app/components/keystone/ui/code_component"
require_relative "../app/components/keystone/ui/disclosure_component"
require_relative "../lib/keystone_ui/safelist"
