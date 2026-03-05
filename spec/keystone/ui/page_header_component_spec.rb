# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::PageHeaderComponent do
  it "exposes title" do
    component = described_class.new(title: "Shopping Lists")

    expect(component.title).to eq("Shopping Lists")
  end

  it "exposes subtitle when provided" do
    component = described_class.new(title: "Lists", subtitle: "Manage your lists")

    expect(component.subtitle?).to be true
    expect(component.subtitle_text).to eq("Manage your lists")
  end

  it "returns false for subtitle? when not provided" do
    component = described_class.new(title: "Lists")

    expect(component.subtitle?).to be false
  end

  it "registers an action block via before_render" do
    component = described_class.new(title: "Lists")
    component.set_content_block do |header|
      header.action { "New List" }
    end

    expect(component.action?).to be false
    component.before_render
    expect(component.action?).to be true
  end

  it "exposes action_url when provided" do
    component = described_class.new(title: "Lists", action_url: "/lists/new")

    expect(component.action_url).to eq("/lists/new")
  end

  it "defaults action_label to Add new" do
    component = described_class.new(title: "Lists", action_url: "/lists/new")

    expect(component.action_label).to eq("Add new")
  end

  it "accepts custom action_label" do
    component = described_class.new(title: "Lists", action_url: "/lists/new", action_label: "New list")

    expect(component.action_label).to eq("New list")
  end

  it "returns nil for action_url when not provided" do
    component = described_class.new(title: "Lists")

    expect(component.action_url).to be_nil
  end
end
