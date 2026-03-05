# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::SettingsLinkComponent do
  it "stores label and href" do
    component = described_class.new(label: "Profile", href: "/profile")

    expect(component.label).to eq("Profile")
    expect(component.href).to eq("/profile")
  end

  it "includes flex layout and padding in link_classes" do
    component = described_class.new(label: "Profile", href: "/profile")

    expect(component.link_classes).to include("flex")
    expect(component.link_classes).to include("items-center")
    expect(component.link_classes).to include("justify-between")
    expect(component.link_classes).to include("px-4")
    expect(component.link_classes).to include("py-3")
  end

  it "includes hover and dark mode classes" do
    component = described_class.new(label: "Profile", href: "/profile")

    expect(component.link_classes).to include("hover:bg-gray-50")
    expect(component.link_classes).to include("dark:hover:bg-gray-800")
  end

  it "has a chevron icon SVG" do
    expect(described_class::CHEVRON_ICON).to include("<svg")
    expect(described_class::CHEVRON_ICON).to include("</svg>")
  end
end
