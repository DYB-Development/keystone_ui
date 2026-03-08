# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::CopyButtonComponent do
  it "returns button classes" do
    component = described_class.new(text: "hello")

    expect(component.classes).to include("rounded-md")
    expect(component.classes).to include("text-sm")
  end

  it "stores text to copy" do
    component = described_class.new(text: "some-value")

    expect(component.text).to eq("some-value")
  end

  it "defaults label to Copy" do
    component = described_class.new(text: "x")

    expect(component.label).to eq("Copy")
  end

  it "accepts custom label" do
    component = described_class.new(text: "x", label: "Copy Token")

    expect(component.label).to eq("Copy Token")
  end

  it "exposes success and error messages" do
    component = described_class.new(text: "x", success_message: "Done!", error_message: "Oops!")

    expect(component.success_message).to eq("Done!")
    expect(component.error_message).to eq("Oops!")
  end

  it "defaults success and error messages" do
    component = described_class.new(text: "x")

    expect(component.success_message).to eq("Copied!")
    expect(component.error_message).to eq("Failed!")
  end
end
