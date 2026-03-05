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
end
