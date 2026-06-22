# frozen_string_literal: true

module KeystoneUi
  # Single source of truth for the Keystone UI API reference. The rake task,
  # the install generator, and the Claude Code subagents all read from here so
  # they can never disagree about how the components are used.
  module Reference
    DIR = File.expand_path("reference", __dir__)

    def self.content
      read("guide.md")
    end

    def self.read(name)
      File.read(File.join(DIR, name)).chomp
    end
  end
end
