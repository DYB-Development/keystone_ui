# frozen_string_literal: true

module KeystoneUi
  class Engine < ::Rails::Engine
    config.autoload_paths << root.join("app/components")

    # Pin JavaScript controllers for importmap-based host apps.
    initializer "keystone_ui.importmap", before: "importmap" do |app|
      if app.config.respond_to?(:importmap)
        app.config.importmap.paths << root.join("config/importmap.rb")
      end
    end

    # Write a separate keystone_source.css with the gem's @source directive
    # so Tailwind can scan component files during asset compilation.
    #
    # Uses after_initialize so host app config/initializers (where
    # KeystoneUi.configure is called) have already run. Dependent engines
    # that also need the palette should use config.after_initialize too —
    # Rails runs these in engine dependency order, so KeystoneUi's block
    # executes before any engine that depends on it.
    config.after_initialize do
      tailwind_dir = Rails.root.join("app/assets/tailwind")
      css_path = tailwind_dir.join("application.css")
      next unless css_path.exist?

      keystone_import = '@import "./keystone_source.css";'
      next unless css_path.read.include?(keystone_import)

      source_css = tailwind_dir.join("keystone_source.css")
      lines = [ %(@source "#{root}/app/components/**/*.{erb,rb}";) ]

      # Import theme CSS (accent + surface custom property defaults)
      theme_css = root.join("app/assets/tailwind/keystone_ui_engine/theme.css")
      lines << %(@import "#{theme_css}";) if theme_css.exist?

      # Import component CSS files shipped with the gem
      nav_css = root.join("app/assets/tailwind/keystone_ui_engine/nav.css")
      lines << %(@import "#{nav_css}";) if nav_css.exist?

      color_picker_css = root.join("app/assets/tailwind/keystone_ui_engine/color_picker.css")
      lines << %(@import "#{color_picker_css}";) if color_picker_css.exist?

      source_css.write(lines.join("\n") + "\n")
    end
  end
end
