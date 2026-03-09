# frozen_string_literal: true

module KeystoneUi
  class Engine < ::Rails::Engine
    config.autoload_paths << root.join("app/components")

    # Placeholder so other engines (e.g. Herald) can order after this.
    initializer "keystone_ui.tailwind_source" do
      # CSS writing happens in after_initialize below
    end

    # Write a separate keystone_source.css with the gem's @source directive
    # so Tailwind can scan component files during asset compilation.
    # Uses after_initialize so host app config/initializers have run first,
    # ensuring custom accent hashes are included in the source inline.
    config.after_initialize do
      tailwind_dir = Rails.root.join("app/assets/tailwind")
      css_path = tailwind_dir.join("application.css")
      next unless css_path.exist?

      keystone_import = '@import "./keystone_source.css";'
      next unless css_path.read.include?(keystone_import)

      source_css = tailwind_dir.join("keystone_source.css")
      lines = [%(@source "#{root}/app/components/**/*.{erb,rb}";)]

      # Include dynamic palette classes (accent + surface) that Tailwind
      # can't discover from static file scanning
      palette_classes = []
      KeystoneUi::AccentColors::PALETTE.each_value do |accent|
        accent.each_value { |v| palette_classes.concat(v.split) }
      end
      KeystoneUi::SurfaceColors::PALETTE.each_value do |surface|
        surface.each_value { |v| palette_classes.concat(v.split) }
      end

      # Include custom accent classes from host app configuration
      accent = KeystoneUi.configuration.accent
      if accent.is_a?(Hash)
        accent.each_value { |v| palette_classes.concat(v.split) }
      end

      lines << %(@source inline("#{palette_classes.uniq.join(" ")}");) if palette_classes.any?

      # Import component CSS files shipped with the gem
      nav_css = root.join("app/assets/tailwind/keystone_ui_engine/nav.css")
      lines << %(@import "#{nav_css}";) if nav_css.exist?

      source_css.write(lines.join("\n") + "\n")
    end
  end
end
