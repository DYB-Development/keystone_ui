# frozen_string_literal: true

RSpec.describe "KeystoneUi::Engine" do
  let(:source) { File.read(File.expand_path("../../lib/keystone_ui/engine.rb", __dir__)) }

  it "does not reference theme CSS files" do
    expect(source).not_to include("themes/base.css")
    expect(source).not_to include("themes/dark.css")
  end

  it "writes keystone_source.css with @source path during app boot" do
    expect(source).to include("keystone_ui.tailwind_source")
    expect(source).to include("keystone_source.css")
    expect(source).to include("app/components/**/*.{erb,rb}")
  end
end
