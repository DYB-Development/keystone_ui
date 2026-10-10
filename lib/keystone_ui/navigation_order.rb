# frozen_string_literal: true

module KeystoneUi
  class NavigationOrder
    def initialize(saved)
      @saved = saved
    end

    def arrange(groups)
      groups.sort_by { |group, _tabs| group_labels.index(group.label) }
    end

    private

    def group_labels
      @saved.map { |entry| entry["group"] }
    end
  end
end
