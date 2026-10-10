# frozen_string_literal: true

module KeystoneUi
  class NavigationOrder
    def initialize(saved)
      @saved = saved
    end

    def arrange(groups)
      groups
        .sort_by { |group, _tabs| group_labels.index(group.label) }
        .map { |group, tabs| [ group, arrange_tabs(group, tabs) ] }
    end

    private

    def group_labels
      @saved.map { |entry| entry["group"] }
    end

    def arrange_tabs(group, tabs)
      keys = saved_tab_keys(group)
      tabs.sort_by { |tab| keys.index(tab.key.to_s) }
    end

    def saved_tab_keys(group)
      @saved.find { |entry| entry["group"] == group.label }&.fetch("tabs", nil) || []
    end
  end
end
