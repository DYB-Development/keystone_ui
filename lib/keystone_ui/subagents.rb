# frozen_string_literal: true

require "keystone_ui/reference"

module KeystoneUi
  # The Keystone UI companion: a suite of Claude Code subagents that a consuming
  # app's orchestrating agent delegates UI work to, so usage stays consistent.
  #
  # Each agent's body embeds KeystoneUi::Reference.content (the single source of
  # truth) — the agents can never disagree with the docs or each other. The
  # `description` field is the delegation trigger: it is what makes the host
  # agent route work here proactively.
  module Subagents
    AGENTS = [
      {
        name: "keystone-scaffold",
        description: "Use PROACTIVELY whenever building or adding UI in this app — " \
          "pages, forms, tables, navigation, dashboards. Produces ERB that composes " \
          "Keystone UI helpers. MUST BE USED instead of hand-writing ERB/Tailwind for UI.",
        tools: "Read, Write, Edit"
      },
      {
        name: "keystone-review",
        description: "Use PROACTIVELY after any UI/ERB change to audit it. Rewrites " \
          "hand-written markup to use Keystone UI helpers and strips freehand Tailwind " \
          "that overrides the components.",
        tools: "Read, Edit, Grep"
      },
      {
        name: "keystone-usage",
        description: "Use for questions about Keystone UI — which helper to use, what " \
          "parameters it takes, how to compose helpers. Answers only; makes no file changes.",
        tools: "Read"
      },
      {
        name: "keystone-install",
        description: "Use to install or update Keystone UI in this app: run the install " \
          "generator, bundle update keystone_ui, re-sync the CLAUDE.md reference, and " \
          "report what changed.",
        tools: "Bash, Read, Edit"
      }
    ].freeze

    def self.names
      AGENTS.map { |agent| agent[:name] }
    end
  end
end
