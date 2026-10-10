# frozen_string_literal: true

module KeystoneUi
  class NavigationGroup
    Tab = Struct.new(:key, :label, :href, :permitted, keyword_init: true)

    attr_reader :label, :tabs

    def initialize(label)
      @label = label
      @tabs = []
    end

    def tab(key, label:, href:, permitted:)
      @tabs << Tab.new(key: key, label: label, href: href, permitted: permitted)
    end
  end
end
