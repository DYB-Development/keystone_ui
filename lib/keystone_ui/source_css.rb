# frozen_string_literal: true

require "pathname"
require "keystone_ui/styles"

module KeystoneUi
  class SourceCss
    def initialize(root, imports: [], sources: [])
      @root = Pathname.new(root)
      @imports = imports
      @sources = sources
    end

    def to_s
      lines.join("\n") + "\n"
    end

    private

    def lines
      [
        %(@import "#{KeystoneUi::Styles.tailwind_file}";),
        %(@source "#{@root}/app/components/**/*.{erb,rb}";),
        %(@import "#{@root}/app/assets/tailwind/keystone_ui_engine/nav.css";),
        %(@import "#{@root}/app/assets/tailwind/keystone_ui_engine/color_picker.css";),
        %(@import "#{@root}/app/assets/tailwind/keystone_ui_engine/grid_safelist.css";),
        *@imports.map { |import| %(@import "#{import}";) },
        *@sources.map { |source| %(@source "#{source}";) }
      ]
    end
  end
end
