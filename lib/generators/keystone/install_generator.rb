# frozen_string_literal: true

require "keystone_ui/subagents"

module Keystone
  class InstallGenerator < Rails::Generators::Base
    desc "Set up Keystone UI in your Rails application"

    TAILWIND_IMPORT = '@import "tailwindcss";'
    KEYSTONE_IMPORT = '@import "./keystone_source.css";'

    JS_CONTROLLERS_PATH = "app/javascript/controllers/index.js"
    JS_IMPORT = 'import { registerControllers } from "keystone_ui/index"'
    JS_REGISTER = "registerControllers(application)"

    def setup_tailwind
      say ""
      say "Keystone UI — setup", :green
      say "=" * 40
      say ""

      css_path = Rails.root.join("app/assets/tailwind/application.css")
      unless css_path.exist?
        FileUtils.mkdir_p(css_path.dirname)
        File.write(css_path, "#{TAILWIND_IMPORT}\n#{KEYSTONE_IMPORT}\n")
        say "  ✔ Created application.css with Tailwind and Keystone imports", :green
        say ""
        say "Done! See the README for component usage.", :green
        return
      end

      content = css_path.read
      changed = false

      # Remove legacy @import for engine CSS (no longer needed)
      legacy_import = '@import "../builds/tailwind/keystone_components_engine";' # also handles pre-rename installs
      if content.include?(legacy_import)
        gsub_file css_path, /#{Regexp.escape(legacy_import)}\n?/, ""
        say "  ✔ Removed legacy engine CSS import", :green
        changed = true
      end

      # Remove legacy inline safelist (replaced by @source path injection)
      legacy_safelist = "/* keystone:safelist */"
      if content.include?(legacy_safelist)
        gsub_file css_path, /#{Regexp.escape(legacy_safelist)}.*\n?/, ""
        say "  ✔ Removed legacy inline safelist", :green
        changed = true
      end

      # Remove legacy marker comment (replaced by @import for keystone_source.css)
      legacy_marker = "/* keystone:source */"
      content = css_path.read # re-read after removals
      if content.include?(legacy_marker)
        gsub_file css_path, /#{Regexp.escape(legacy_marker)}.*\n?/, ""
        say "  ✔ Removed legacy source marker", :green
        changed = true
      end

      # Inject @import for keystone_source.css (written at boot by engine initializer)
      content = css_path.read # re-read after removals
      unless content.include?(KEYSTONE_IMPORT)
        inject_into_file css_path, "#{KEYSTONE_IMPORT}\n", after: /#{Regexp.escape(TAILWIND_IMPORT)}\n/
        say "  ✔ Added Keystone source import", :green
        changed = true
      end

      say "  ✔ application.css already up to date", :green unless changed
      say ""
      say "Done! See the README for component usage.", :green
    end

    def setup_javascript
      say ""
      say "Wiring Keystone UI Stimulus controllers...", :green

      js_path = Rails.root.join(JS_CONTROLLERS_PATH)
      unless js_path.exist?
        say "  ⚠ #{JS_CONTROLLERS_PATH} not found — add `#{JS_REGISTER}` to your Stimulus setup manually.", :yellow
        return
      end

      if js_path.read.include?(JS_REGISTER)
        say "  ✔ Keystone UI controllers already registered", :green
        return
      end

      append_to_file js_path, "\n#{JS_IMPORT}\n#{JS_REGISTER}\n"
      say "  ✔ Registered Keystone UI controllers", :green
    end

    def generate_claude_docs
      say ""
      say "Generating CLAUDE.md API reference...", :green
      rake "keystone:claude"
    end

    def generate_subagents
      say ""
      say "Installing Keystone UI Claude Code subagents...", :green
      KeystoneUi::Subagents.names.each do |name|
        create_file ".claude/agents/#{name}.md", KeystoneUi::Subagents.content_for(name), force: true
      end
    end
  end
end
