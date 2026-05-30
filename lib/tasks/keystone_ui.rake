# frozen_string_literal: true

require "keystone_ui/reference"

namespace :keystone do
  desc "Inject @source path into application.css for Tailwind to scan component files"
  task inject_source: :environment do
    css_path = Rails.root.join("app/assets/tailwind/application.css")
    next unless css_path.exist?

    content = css_path.read
    marker = "/* keystone:source */"
    gem_path = KeystoneUi::Engine.root
    source_line = "#{marker} @source \"#{gem_path}/app/components/**/*.{erb,rb}\";"

    if content.include?(marker)
      updated = content.sub(/#{Regexp.escape(marker)}.*$/, source_line)
      css_path.write(updated)
    end
  end

  desc "Restore marker-only line after Tailwind build (no local path committed)"
  task :clean_source do
    css_path = Rails.root.join("app/assets/tailwind/application.css")
    next unless css_path.exist?

    content = css_path.read
    marker = "/* keystone:source */"

    if content.include?(marker)
      updated = content.sub(/#{Regexp.escape(marker)}.*$/, marker)
      css_path.write(updated)
    end
  end

  desc "Append Keystone UI API reference to CLAUDE.md"
  task :claude do
    section_heading = "## Keystone UI"
    content = KeystoneUi::Reference.content

    path = File.join(Dir.pwd, "CLAUDE.md")

    if File.exist?(path)
      existing = File.read(path)

      if existing.include?(section_heading)
        updated = existing.sub(/#{Regexp.escape(section_heading)}\n.*\z/m, "#{content}\n")
        File.write(path, updated)
      else
        File.write(path, "#{existing.chomp}\n\n#{content}\n")
      end
    else
      File.write(path, "#{content}\n")
    end

    puts "Keystone UI API reference written to #{path}"
  end
end
