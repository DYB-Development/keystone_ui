# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::BottomNavItemComponent do
  it "stores label, href, and icon" do
    component = described_class.new(label: "Home", href: "/", icon: "<svg></svg>")

    expect(component.label).to eq("Home")
    expect(component.href).to eq("/")
    expect(component.icon).to eq("<svg></svg>")
  end

  it "returns base class when not active" do
    component = described_class.new(label: "Home", href: "/", icon: "<svg></svg>")

    expect(component.item_classes).to eq("bottom-nav-item")
  end

  it "includes active class when active" do
    component = described_class.new(label: "Home", href: "/", icon: "<svg></svg>", active: true)

    expect(component.item_classes).to eq("bottom-nav-item active")
  end
end
