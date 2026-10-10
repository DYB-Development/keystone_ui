# frozen_string_literal: true

require "keystone_ui/navigation_group"

module KeystoneUi
  class Configuration
    attr_accessor :accent, :surface, :theme_mode_supplier, :look_supplier, :trail_supplier, :preference_supplier, :current_tab_supplier
    attr_reader :tailwind_imports, :tailwind_sources, :looks, :default_look, :navigation_groups

    def initialize
      @accent = :blue
      @surface = :zinc
      @tailwind_imports = []
      @tailwind_sources = []
      @looks = {}
      @navigation_groups = []
    end

    def default_look=(name)
      @default_look = name&.to_s
    end

    def register_look(name, path)
      @looks[name.to_s] = path.to_s
      @tailwind_imports << path.to_s
    end

    def navigation_group(label)
      group = NavigationGroup.new(label)
      yield(group)
      @navigation_groups << group
    end

    def supplied_look(view)
      look_supplier&.call(view)&.to_s
    end

    def supplied_theme_mode(view)
      theme_mode_supplier&.call(view)
    end

    def supplied_trail(view)
      trail_supplier&.call(view)
    end

    def supplied_preference(view, key)
      preference_supplier&.call(view, key)
    end

    def supplied_current_tab(view)
      current_tab_supplier&.call(view)
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.reset_configuration!
    @configuration = Configuration.new
  end
end
