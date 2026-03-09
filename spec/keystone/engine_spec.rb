# frozen_string_literal: true

RSpec.describe "KeystoneUi::Engine" do
  let(:source) { File.read(File.expand_path("../../lib/keystone_ui/engine.rb", __dir__)) }

  it "does not reference theme CSS files" do
    expect(source).not_to include("themes/base.css")
    expect(source).not_to include("themes/dark.css")
  end

  it "writes keystone_source.css with @source path during app boot" do
    expect(source).to include("after_initialize")
    expect(source).to include("keystone_source.css")
    expect(source).to include("app/components/**/*.{erb,rb}")
  end

  it "imports nav.css in keystone_source.css" do
    expect(source).to include("nav.css")
    expect(source).to include('@import "#{nav_css}"')
  end
end
