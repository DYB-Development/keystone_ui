# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::FormComponent do
  it "builds form_options with url and default post method" do
    component = described_class.new(action: "/items")
    options = component.form_options

    expect(options[:url]).to eq("/items")
    expect(options[:method]).to eq(:post)
    expect(options[:class]).to eq("space-y-6")
    expect(options[:multipart]).to be false
  end

  it "passes explicit method through for form_with" do
    component = described_class.new(action: "/items/1", method: :patch)

    expect(component.form_options[:method]).to eq(:patch)
  end

  it "enables multipart when requested" do
    component = described_class.new(action: "/uploads", multipart: true)

    expect(component.form_options[:multipart]).to be true
  end

  it "accepts data attributes" do
    component = described_class.new(action: "/items", data: { turbo: true })

    expect(component.form_options[:data]).to eq({ turbo: true })
  end

  it "omits data key when not provided" do
    component = described_class.new(action: "/items")

    expect(component.form_options).not_to have_key(:data)
  end
end
