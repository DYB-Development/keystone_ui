# frozen_string_literal: true

require "pathname"

module KeystoneUi
  class LeftoverStylesheet
    def initialize(root)
      @root = Pathname.new(root)
    end

    def remove
      @root.join("app/assets/builds/tailwind/keystone_ui_engine.css").delete
    end
  end
end
