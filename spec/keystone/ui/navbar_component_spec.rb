# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::NavbarComponent do
  it "includes top-nav and sticky classes by default" do
    component = described_class.new

    expect(component.nav_classes).to include("top-nav")
    expect(component.nav_classes).to include("sticky")
    expect(component.nav_classes).to include("top-0")
    expect(component.nav_classes).to include("z-40")
  end

  it "omits sticky classes when sticky: false" do
    component = described_class.new(sticky: false)

    expect(component.nav_classes).to include("top-nav")
    expect(component.nav_classes).not_to include("sticky")
  end

  it "has MOBILE_LEFT_CLASSES hidden on desktop" do
    expect(described_class::MOBILE_LEFT_CLASSES).to include("lg:hidden")
    expect(described_class::MOBILE_LEFT_CLASSES).to include("flex")
  end

  it "has DESKTOP_LINKS_CLASSES hidden on mobile" do
    expect(described_class::DESKTOP_LINKS_CLASSES).to include("hidden")
    expect(described_class::DESKTOP_LINKS_CLASSES).to include("lg:flex")
  end

  it "has MOBILE_CENTER_CLASSES with centered positioning" do
    expect(described_class::MOBILE_CENTER_CLASSES).to include("absolute")
    expect(described_class::MOBILE_CENTER_CLASSES).to include("-translate-x-1/2")
    expect(described_class::MOBILE_CENTER_CLASSES).to include("truncate")
  end
end
