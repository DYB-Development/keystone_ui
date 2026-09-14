# frozen_string_literal: true

require "pathname"

module KeystoneUi
  class SourceCss
    def initialize(root)
      @root = Pathname.new(root)
    end

    def to_s
      lines.join("\n") + "\n"
    end

    private

    def lines
      [
        %(@source "#{@root}/app/components/**/*.{erb,rb}";),
        %(@import "#{@root}/app/assets/tailwind/keystone_ui_engine/nav.css";)
      ]
    end
  end
end
