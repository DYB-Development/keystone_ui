# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::SelectComponent do
  it "returns base classes" do
    component = described_class.new(name: "status")

    expect(component.classes).to include("rounded-md")
    expect(component.classes).to include("border")
    expect(component.classes).to include("text-sm")
  end

  it "appends disabled classes when disabled" do
    component = described_class.new(name: "status", disabled: true)

    expect(component.classes).to include("cursor-not-allowed")
  end

  it "stores name" do
    component = described_class.new(name: "event_name")

    expect(component.tag_options[:name]).to eq("event_name")
  end

  it "includes disabled attribute when disabled" do
    component = described_class.new(name: "x", disabled: true)

    expect(component.tag_options[:disabled]).to be true
  end

  it "stores options list" do
    opts = [["Active", "active"], ["Inactive", "inactive"]]
    component = described_class.new(name: "status", options: opts)

    expect(component.options).to eq(opts)
  end

  it "stores selected value" do
    component = described_class.new(name: "status", selected: "active")

    expect(component.selected).to eq("active")
  end

  it "stores include_blank" do
    component = described_class.new(name: "status", include_blank: "All")

    expect(component.include_blank).to eq("All")
  end

  it "uses semantic accent classes for focus state" do
    component = described_class.new(name: "status")

    expect(component.classes).to include("focus:border-accent-500")
    expect(component.classes).to include("focus:ring-accent-500")
  end
end
