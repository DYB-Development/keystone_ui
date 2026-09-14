# frozen_string_literal: true

require "keystone_ui/source_css"
require "keystone_ui/leftover_stylesheet"

module KeystoneUi
  class Engine < ::Rails::Engine
    config.autoload_paths << root.join("app/components")

    # Pin JavaScript controllers for importmap-based host apps.
    initializer "keystone_ui.importmap", before: "importmap" do |app|
      if app.config.respond_to?(:importmap)
        app.config.importmap.paths << root.join("config/importmap.rb")
      end
    end

    initializer "keystone_ui.remove_leftover_stylesheet" do |app|
      KeystoneUi::LeftoverStylesheet.new(app.root).remove
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

      tailwind_dir.join("keystone_source.css").write(KeystoneUi::SourceCss.new(root, imports: KeystoneUi.configuration.tailwind_imports, sources: KeystoneUi.configuration.tailwind_sources).to_s)
    end
  end
end
