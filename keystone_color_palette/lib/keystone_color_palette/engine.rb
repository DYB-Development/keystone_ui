# frozen_string_literal: true

module KeystoneColorPalette
  class Engine < ::Rails::Engine
    isolate_namespace KeystoneColorPalette

    initializer "keystone_color_palette.autoload" do |app|
      app.config.autoload_paths += Dir[root.join("app", "models")]
      app.config.autoload_paths += Dir[root.join("app", "controllers")]
    end
  end
end
