# frozen_string_literal: true

module KeystoneUi
  class NavigationGroup
    Tab = Struct.new(:key, :label, :href, :permitted, keyword_init: true) do
      def href_for(view)
        href.respond_to?(:call) ? href.call(view) : href
      end
    end

    attr_reader :label, :tabs

    def initialize(label)
      @label = label
      @tabs = []
    end

    def tabs_permitted_for(view)
      tabs.select { |tab| tab.permitted.call(view) }
    end

    def tab(key, label:, href:, permitted:)
      @tabs << Tab.new(key: key, label: label, href: href, permitted: permitted)
    end
  end
end
