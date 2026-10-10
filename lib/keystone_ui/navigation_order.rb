# frozen_string_literal: true

module KeystoneUi
  class NavigationOrder
    def initialize(saved)
      @saved = saved.is_a?(Array) ? saved : []
    end

    def arrange(groups)
      in_saved_order(groups, group_labels) { |group, _tabs| group.label }
        .map { |group, tabs| [ group, arrange_tabs(group, tabs) ] }
    end

    private

    def in_saved_order(items, saved_names)
      items.each_with_index
        .sort_by { |item, declared| [ saved_names.index(yield(item)) || saved_names.size, declared ] }
        .map(&:first)
    end

    def group_labels
      @saved.map { |entry| entry["group"] }
    end

    def arrange_tabs(group, tabs)
      in_saved_order(tabs, saved_tab_keys(group)) { |tab| tab.key.to_s }
    end

    def saved_tab_keys(group)
      @saved.find { |entry| entry["group"] == group.label }&.fetch("tabs", nil) || []
    end
  end
end
