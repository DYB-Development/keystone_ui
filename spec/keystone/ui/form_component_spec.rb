# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::FormComponent do
  it "requires action" do
    component = described_class.new(action: "/items")

    expect(component.action).to eq("/items")
  end

  it "defaults method to post" do
    component = described_class.new(action: "/items")

    expect(component.form_method).to eq("post")
  end

  it "accepts explicit method" do
    component = described_class.new(action: "/items/1", method: :patch)

    expect(component.form_method).to eq("post")
    expect(component.method_override).to eq("patch")
  end

  it "does not set method_override for get" do
    component = described_class.new(action: "/items", method: :get)

    expect(component.form_method).to eq("get")
    expect(component.method_override).to be_nil
  end

  it "does not set method_override for post" do
    component = described_class.new(action: "/items", method: :post)

    expect(component.form_method).to eq("post")
    expect(component.method_override).to be_nil
  end

  it "enables multipart when requested" do
    component = described_class.new(action: "/uploads", multipart: true)

    expect(component.multipart?).to be true
  end

  it "defaults multipart to false" do
    component = described_class.new(action: "/items")

    expect(component.multipart?).to be false
  end

  it "builds tag_options with action and method" do
    component = described_class.new(action: "/items")
    options = component.tag_options

    expect(options[:action]).to eq("/items")
    expect(options[:method]).to eq("post")
  end

  it "includes enctype for multipart forms" do
    component = described_class.new(action: "/uploads", multipart: true)
    options = component.tag_options

    expect(options[:enctype]).to eq("multipart/form-data")
  end

  it "omits enctype for non-multipart forms" do
    component = described_class.new(action: "/items")

    expect(component.tag_options).not_to have_key(:enctype)
  end

  it "accepts data attributes" do
    component = described_class.new(action: "/items", data: { turbo: true })
    options = component.tag_options

    expect(options[:data]).to eq({ turbo: true })
  end
end
