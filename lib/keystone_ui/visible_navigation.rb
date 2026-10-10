# frozen_string_literal: true

require "keystone_ui/navigation_order"

module KeystoneUi
  class VisibleNavigation
    Group = Struct.new(:label, :tabs, keyword_init: true)

    def initialize(declared_groups, view:, saved_order:, current_tab:)
      @declared_groups = declared_groups
      @view = view
      @saved_order = saved_order
    end

    def groups
      NavigationOrder.new(@saved_order).arrange(permitted)
        .map { |group, tabs| Group.new(label: group.label, tabs: tabs) }
    end

    private

    def permitted
      @declared_groups
        .map { |group| [ group, group.tabs_permitted_for(@view) ] }
        .reject { |_group, tabs| tabs.empty? }
    end
  end
end
