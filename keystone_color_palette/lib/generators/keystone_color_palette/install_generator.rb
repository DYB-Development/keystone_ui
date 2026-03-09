# frozen_string_literal: true

module KeystoneColorPalette
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../../db/migrate", __dir__)

      desc "Install Keystone Color Palette: copy migration and print setup instructions"

      def copy_migration
        timestamp = Time.now.strftime("%Y%m%d%H%M%S")
        copy_file "001_create_keystone_theme_preferences.rb",
                  "db/migrate/#{timestamp}_create_keystone_theme_preferences.rb"
      end

      def print_instructions
        say ""
        say "Keystone Color Palette installed!", :green
        say ""
        say "Next steps:"
        say ""
        say "  1. Run the migration:"
        say "     rails db:migrate"
        say ""
        say "  2. Mount the engine in config/routes.rb:"
        say '     mount KeystoneColorPalette::Engine, at: "/settings/palette"'
        say ""
        say "  3. Include the concern in ApplicationController:"
        say "     include KeystoneColorPalette::CurrentPalette"
        say ""
        say "  4. (Optional) Create an initializer config/initializers/keystone_color_palette.rb:"
        say ""
        say "     KeystoneColorPalette.configure do |c|"
        say '       c.owner_class_name = "User"            # Your user model'
        say "       c.current_owner_method = :current_user  # Controller method for current user"
        say "       c.default_template = :ocean             # Default theme"
        say "     end"
        say ""
      end
    end
  end
end
