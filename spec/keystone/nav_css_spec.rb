# frozen_string_literal: true

RSpec.describe "nav.css" do
  let(:css_path) { File.expand_path("../../app/assets/tailwind/keystone_ui_engine/nav.css", __dir__) }
  let(:css) { File.read(css_path) }

  it "exists" do
    expect(File.exist?(css_path)).to be true
  end

  it "defines .bottom-nav styles" do
    expect(css).to include(".bottom-nav")
    expect(css).to include("position: fixed")
  end

  it "defines .bottom-nav-item styles" do
    expect(css).to include(".bottom-nav-item")
    expect(css).to include("flex-direction: column")
  end

  it "defines .bottom-nav-label styles" do
    expect(css).to include(".bottom-nav-label")
  end

  it "includes safe-area-inset for notched devices" do
    expect(css).to include("safe-area-inset-bottom")
  end

  it "includes mobile padding for main content" do
    expect(css).to include("padding-bottom")
  end
end
