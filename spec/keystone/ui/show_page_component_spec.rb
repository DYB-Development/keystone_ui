# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::ShowPageComponent do
  it "exposes title" do
    component = described_class.new(title: "Invoice #42", back_url: "/invoices")

    expect(component.instance_variable_get(:@title)).to eq("Invoice #42")
  end

  it "exposes back_url" do
    component = described_class.new(title: "Invoice #42", back_url: "/invoices")

    expect(component.instance_variable_get(:@back_url)).to eq("/invoices")
  end

  it "stores subtitle when provided" do
    component = described_class.new(title: "Invoice #42", back_url: "/invoices", subtitle: "Paid")

    expect(component.instance_variable_get(:@subtitle)).to eq("Paid")
  end

  it "defaults subtitle to nil" do
    component = described_class.new(title: "Invoice #42", back_url: "/invoices")

    expect(component.instance_variable_get(:@subtitle)).to be_nil
  end
end
