# frozen_string_literal: true

module KeystoneUi
  class Engine < ::Rails::Engine
    config.autoload_paths << root.join("app/components")

    # Write a separate keystone_source.css with the gem's @source directive
    # so Tailwind can scan component files during asset compilation.
    # Runs during app boot (before assets:precompile triggers tailwindcss:build).
    initializer "keystone_ui.tailwind_source" do
      tailwind_dir = Rails.root.join("app/assets/tailwind")
      css_path = tailwind_dir.join("application.css")
      next unless css_path.exist?

      keystone_import = '@import "./keystone_source.css";'
      next unless css_path.read.include?(keystone_import)

      source_css = tailwind_dir.join("keystone_source.css")
      lines = [%(@source "#{root}/app/components/**/*.{erb,rb}";)]

      # Import component CSS files shipped with the gem
      nav_css = root.join("app/assets/tailwind/keystone_ui_engine/nav.css")
      lines << %(@import "#{nav_css}";) if nav_css.exist?

      source_css.write(lines.join("\n") + "\n")
    end
  end
end
