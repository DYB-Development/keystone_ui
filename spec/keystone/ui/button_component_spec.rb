# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::ButtonComponent do
  it "combines base, variant, and size classes" do
    component = described_class.new(label: "Create invoice", variant: :secondary, size: :lg)

    expect(component.classes).to eq("inline-flex items-center justify-center font-semibold rounded-lg border-0 cursor-pointer no-underline bg-gray-500 text-white hover:bg-gray-400 text-lg px-5 py-3")
  end

  it "defaults to submit type when rendering a button element" do
    component = described_class.new(label: "Create invoice")

    expect(component.tag_options[:type]).to eq("submit")
  end

  it "allows overriding the button type" do
    component = described_class.new(label: "Cancel", type: :button)

    expect(component.tag_options[:type]).to eq("button")
  end

  context "with custom accent" do
    after { KeystoneUi.reset_configuration! }

    it "uses accent colors for primary variant" do
      KeystoneUi.configure { |c| c.accent = :emerald }
      component = described_class.new(label: "Save")

      expect(component.classes).to include("bg-emerald-600")
      expect(component.classes).to include("hover:bg-emerald-500")
      expect(component.classes).not_to include("indigo")
    end
  end
end
