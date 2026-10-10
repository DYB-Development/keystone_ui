# frozen_string_literal: true

module KeystoneUi
  class VisibleNavigation
    Group = Struct.new(:label, :tabs, keyword_init: true)

    def initialize(declared_groups, view:, saved_order:, current_tab:)
      @declared_groups = declared_groups
      @view = view
    end

    def groups
      @declared_groups
        .map { |group| Group.new(label: group.label, tabs: group.tabs_permitted_for(@view)) }
        .reject { |group| group.tabs.empty? }
    end
  end
end
