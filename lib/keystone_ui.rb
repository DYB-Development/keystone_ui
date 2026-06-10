# frozen_string_literal: true

require "view_component"
require "keystone_ui/configuration"
require "keystone_ui/engine"
require "keystone_ui/version"
require "keystone_ui/the_local"

module KeystoneUi
end

require "keystone_ui/current" if defined?(ActiveSupport::CurrentAttributes)
