# frozen_string_literal: true

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
end
