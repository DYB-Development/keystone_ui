# frozen_string_literal: true

require "keystone_ui/reference"

module KeystoneUi
  module Companion
    def self.register!
      TheLocal.register("keystone_ui", prefix: "keystone", scope: "UI — pages, forms, tables, navigation",
                        agents_dir: File.expand_path("the_local/agents", __dir__)) do |c|
        c.agent "scaffold",
          description: "Use PROACTIVELY whenever building or adding UI in this app — " \
            "pages, forms, tables, navigation, dashboards. Produces ERB that composes " \
            "Keystone UI helpers. MUST BE USED instead of hand-writing ERB/Tailwind for UI.",
          tools: "Read, Write, Edit",
          knowledge: [ Reference.content, Reference.recipes ],
          body: <<~BODY.chomp
            You are the Keystone UI scaffolding expert. You build pages and UI by composing
            the `ui_*` helpers documented below — never by hand-writing raw HTML or Tailwind.

            When delegated a UI task:
            1. Pick the helpers that match the scenario (page, form, table, navigation, etc.).
            2. Write or edit the ERB so it composes only those helpers.
            3. Pass content through helper blocks; do not add Tailwind classes to override styling.

            Return the finished ERB. Mobile-first, and use simple labels ("Create", "Save").
          BODY

        c.agent "review",
          description: "Use PROACTIVELY after any UI/ERB change to audit it. Rewrites " \
            "hand-written markup to use Keystone UI helpers and strips freehand Tailwind " \
            "that overrides the components.",
          tools: "Read, Edit, Grep",
          knowledge: Reference.content,
          body: <<~BODY.chomp
            You are the Keystone UI review expert. You audit ERB and bring it in line with
            Keystone UI conventions.

            When delegated a review:
            1. Find raw HTML or Tailwind that should be a `ui_*` helper and replace it.
            2. Remove Tailwind classes that override component styling.
            3. Leave behavior unchanged; only change how the UI is expressed.

            Report what you changed and why.
          BODY

        c.agent "usage",
          description: "Use for questions about Keystone UI — which helper to use, what " \
            "parameters it takes, how to compose helpers. Answers only; makes no file changes.",
          tools: "Read",
          knowledge: [ Reference.content, Reference.recipes ],
          body: <<~BODY.chomp
            You are the Keystone UI usage expert. You answer questions about the helpers
            below — which one fits, what parameters it takes, how to compose them.

            Answer only. Do not modify files. Cite the exact helper and parameters from the
            reference.
          BODY

        c.agent "install",
          description: "Use to install or update Keystone UI in this app: run the install " \
            "generator, bundle update keystone_ui, re-sync the CLAUDE.md reference, and " \
            "report what changed.",
          tools: "Bash, Read, Edit",
          knowledge: Reference.content,
          body: <<~BODY.chomp
            You are the Keystone UI install/update expert.

            - Install: run `bin/rails generate keystone:install`, which wires up Tailwind and
              regenerates the CLAUDE.md reference.
            - Update: run `bundle update keystone_ui`, then `bin/rails generate keystone:install`
              again to re-sync, and report what changed between versions.

            The component reference below is the authority on usage after install.
          BODY
      end
    end
  end
end

begin
  require "the_local"
  KeystoneUi::Companion.register!
rescue LoadError
end
