# frozen_string_literal: true

require "logger"
require "rails"
require "action_controller/railtie"
require "keystone_ui"

module KeystoneUiRender
  class Application < Rails::Application
    config.root = File.expand_path("render", __dir__)
    config.eager_load = false
    config.logger = Logger.new(nil)
    config.secret_key_base = "keystone_ui render tests"
  end
end

KeystoneUiRender::Application.initialize!

class ApplicationController < ActionController::Base
end

require "view_component/test_helpers"
require "view_component/test_case"
require "minitest/autorun"
