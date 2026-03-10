# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::CardComponent do
  it "returns CARD_CLASSES by default" do
    component = described_class.new(title: "Revenue", summary: "$42k", link: "/reports")

    expect(component.send(:card_classes)).to eq(described_class::CARD_CLASSES)
  end

  it "returns CARD_EDGE_CLASSES when edge_to_edge is true" do
    component = described_class.new(title: "Revenue", summary: "$42k", link: "/reports", edge_to_edge: true)

    expect(component.send(:card_classes)).to eq(described_class::CARD_EDGE_CLASSES)
  end

  it "defaults cta to 'Read more'" do
    component = described_class.new(title: "Revenue", summary: "$42k", link: "/reports")

    expect(component.instance_variable_get(:@cta)).to eq("Read more")
  end

  it "accepts a custom cta" do
    component = described_class.new(title: "Revenue", summary: "$42k", link: "/reports", cta: "View details")

    expect(component.instance_variable_get(:@cta)).to eq("View details")
  end

  it "uses semantic accent classes for link" do
    component = described_class.new(title: "X", summary: "Y", link: "/z")

    expect(component.link_classes).to include("text-accent-600")
    expect(component.link_classes).to include("hover:text-accent-900")
    expect(component.link_classes).to include("dark:text-accent-400")
  end
end
