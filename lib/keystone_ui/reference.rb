# frozen_string_literal: true

module KeystoneUi
  # Single source of truth for the Keystone UI API reference. The rake task,
  # the install generator, and the Claude Code subagents all read from here so
  # they can never disagree about how the components are used.
  module Reference
    PATH = File.expand_path("reference/components.md", __dir__)

    def self.content
      File.read(PATH).chomp
    end
  end
end
