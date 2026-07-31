# Releasing

Cutting a release of `keystone_ui` to [RubyGems.org](https://rubygems.org).

## Prerequisites

- A RubyGems.org account with push rights on `keystone_ui`.
- **MFA is required** — the gemspec sets `rubygems_mfa_required = "true"`, so
  `gem push` prompts for a one-time password. There is no way to push without it;
  a plain API key is not enough.
- `gem signin` has been run at least once on this machine.

## Steps

1. Confirm `main` is green and up to date:

   ```bash
   git checkout main && git pull
   bundle exec rake test
   bin/rubocop
   ```

2. Bump `VERSION` in `lib/keystone_ui/version.rb`.

3. Move the `## [Unreleased]` entries in `CHANGELOG.md` under a new
   `## [X.Y.Z] - YYYY-MM-DD` heading and leave a fresh empty `## [Unreleased]`
   above it.

4. Commit the bump, open a PR, and merge it.

5. Build and inspect the gem before pushing:

   ```bash
   gem build keystone_ui.gemspec
   tar -xOf keystone_ui-X.Y.Z.gem data.tar.gz | tar -tzf -
   ```

   The listing must include `app/components/**` (`.rb` and `.html.erb`),
   `app/assets/**`, `config/importmap.rb`, and `lib/keystone_ui/the_local/**`.
   `test/keystone_ui/packaging_test.rb` guards this, but eyeball it anyway.

6. Push, entering the OTP when prompted:

   ```bash
   gem push keystone_ui-X.Y.Z.gem
   ```

7. Tag the release and push the tag:

   ```bash
   git tag vX.Y.Z
   git push origin vX.Y.Z
   ```

8. Verify from a clean environment:

   ```bash
   gem install keystone_ui -v X.Y.Z
   ```

9. Delete the local `.gem` build artifact.

## Automating the push

A tag-triggered GitHub Actions release is possible via RubyGems
[trusted publishing](https://guides.rubygems.org/trusted-publishing/), which uses
OIDC instead of an API key and satisfies the MFA requirement. It has to be
configured on the gem's RubyGems.org settings page first, so it can only be set
up after the first manual push above.
