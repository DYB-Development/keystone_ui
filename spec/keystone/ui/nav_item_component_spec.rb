# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::NavItemComponent do
  it "stores label and href" do
    component = described_class.new(label: "Dashboard", href: "/dashboard")

    expect(component.label).to eq("Dashboard")
    expect(component.href).to eq("/dashboard")
  end

  it "returns empty string for link_classes when not active" do
    component = described_class.new(label: "Dashboard", href: "/dashboard")

    expect(component.link_classes).to eq("")
  end

  it "returns active class when active" do
    component = described_class.new(label: "Dashboard", href: "/dashboard", active: true)

    expect(component.link_classes).to eq("active")
  end
end
