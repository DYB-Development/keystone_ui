# frozen_string_literal: true

require "keystone_ui/reference"

module KeystoneUi
  module Companion
    def self.register!
      TheLocal.register("keystone_ui", scope: "UI — pages, forms, tables, navigation, dashboards",
                        agents_dir: File.expand_path("the_local/agents", __dir__)) do |c|
        c.agent "info",
                description: "Use to learn what Keystone UI offers — which `ui_*` helper " \
                  "fits a scenario, what parameters it takes, how helpers compose. " \
                  "Answers only; makes no file changes.",
                tools: "Read",
                body: "You explain what Keystone UI does, answering only from your reference. " \
                  "You name the exact `ui_*` helper and its parameters, and show how helpers " \
                  "compose for pages, forms, tables, navigation, and dashboards. You make no " \
                  "changes and never read keystone_ui's source.",
                knowledge: KeystoneUi::Reference.content

        c.agent "install",
                description: "Use to install or update Keystone UI in a host app: add the " \
                  "gem, run the install generator to wire Tailwind and Stimulus, regenerate " \
                  "the CLAUDE.md reference, and report what changed.",
                tools: "Bash, Read, Edit",
                body: "You install and update Keystone UI in a host Rails app by following " \
                  "your reference's Install section exactly. You add the gem, run " \
                  "`bin/rails generate keystone:install` to wire Tailwind and Stimulus and " \
                  "regenerate the CLAUDE.md reference, and report what changed. After install " \
                  "your reference is the authority on usage. You never read keystone_ui's source.",
                knowledge: KeystoneUi::Reference.content

        c.agent "develop",
                description: "Use PROACTIVELY for any Keystone UI work — building or editing " \
                  "pages, forms, tables, navigation, and dashboards. Produces ERB that " \
                  "composes `ui_*` helpers. MUST BE USED instead of hand-writing ERB/Tailwind.",
                tools: "Read, Write, Edit, Grep",
                body: "You do Keystone UI work by following your reference's Interface, Recipe, " \
                  "and Conventions exactly. You build pages and UI by composing the `ui_*` " \
                  "helpers — never by hand-writing raw HTML or Tailwind, and never by adding " \
                  "Tailwind classes that override a component's styling. You pick the helpers " \
                  "that match the scenario, write or edit the ERB to compose only those " \
                  "helpers, and keep it mobile-first with simple labels (\"Create\", \"Save\"). " \
                  "You implement from the reference, never keystone_ui's source.",
                knowledge: KeystoneUi::Reference.content
      end
    end
  end
end

begin
  require "the_local"
  KeystoneUi::Companion.register!
rescue LoadError
  # the_local not installed — keystone_ui works standalone.
end
