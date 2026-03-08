# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::NavDropdownComponent do
  it "stores title" do
    component = described_class.new(title: "Plan", area: :plan, active: false)

    expect(component.title).to eq("Plan")
  end

  it "includes active class on trigger when active" do
    component = described_class.new(title: "Plan", area: :plan, active: true)

    expect(component.trigger_classes).to include("active")
  end

  it "excludes active class on trigger when not active" do
    component = described_class.new(title: "Plan", area: :plan, active: false)

    expect(component.trigger_classes).not_to include("active")
  end
end
