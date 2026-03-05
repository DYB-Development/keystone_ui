# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::BottomNavComponent do
  it "includes bottom-nav in nav_classes" do
    component = described_class.new

    expect(component.nav_classes).to include("bottom-nav")
  end

  it "includes lg:hidden to hide on desktop" do
    component = described_class.new

    expect(component.nav_classes).to include("lg:hidden")
  end

  it "includes hotwire-native:hidden to hide in native apps" do
    component = described_class.new

    expect(component.nav_classes).to include("hotwire-native:hidden")
  end
end
