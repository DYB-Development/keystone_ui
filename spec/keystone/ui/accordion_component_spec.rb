# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::AccordionComponent do
  it "returns base wrapper classes" do
    component = described_class.new

    expect(component.classes).to eq("flex flex-col gap-4")
  end
end
