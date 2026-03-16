# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::FileUploadComponent do
  it "requires a name" do
    component = described_class.new(name: "avatar")

    expect(component.input_name).to eq("avatar")
  end

  it "defaults to single file upload" do
    component = described_class.new(name: "avatar")

    expect(component.multiple?).to be false
  end

  it "supports multiple file uploads" do
    component = described_class.new(name: "documents", multiple: true)

    expect(component.multiple?).to be true
  end

  it "accepts allowed file types" do
    component = described_class.new(name: "photo", accept: "image/*")

    expect(component.accept).to eq("image/*")
  end

  it "returns nil accept when not specified" do
    component = described_class.new(name: "file")

    expect(component.accept).to be_nil
  end

  it "provides a default label" do
    component = described_class.new(name: "document")

    expect(component.label_text).to eq("Choose file")
  end

  it "accepts a custom label" do
    component = described_class.new(name: "photo", label: "Upload photo")

    expect(component.label_text).to eq("Upload photo")
  end

  it "exposes hint? and hint_text" do
    component = described_class.new(name: "avatar", hint: "Max 5MB")

    expect(component.hint?).to be true
    expect(component.hint_text).to eq("Max 5MB")
  end

  it "returns false for hint? when no hint" do
    component = described_class.new(name: "avatar")

    expect(component.hint?).to be false
  end

  it "builds tag_options for single file input" do
    component = described_class.new(name: "avatar", accept: "image/*")
    options = component.tag_options

    expect(options[:type]).to eq("file")
    expect(options[:name]).to eq("avatar")
    expect(options[:accept]).to eq("image/*")
    expect(options).not_to have_key(:multiple)
  end

  it "builds tag_options for multiple file input" do
    component = described_class.new(name: "documents[]", multiple: true)
    options = component.tag_options

    expect(options[:name]).to eq("documents[]")
    expect(options[:multiple]).to be true
  end

  it "omits accept from tag_options when not specified" do
    component = described_class.new(name: "file")

    expect(component.tag_options).not_to have_key(:accept)
  end

  it "wires the file-upload Stimulus controller on the wrapper" do
    component = described_class.new(name: "avatar")

    expect(component.wrapper_data).to eq({ controller: "file-upload" })
  end

  it "marks the drop zone as a Stimulus target" do
    component = described_class.new(name: "avatar")

    expect(component.drop_zone_data[:"file-upload-target"]).to eq("dropZone")
  end

  it "marks the input as a Stimulus target with change action" do
    component = described_class.new(name: "avatar")

    expect(component.input_data[:"file-upload-target"]).to eq("input")
    expect(component.input_data[:action]).to eq("change->file-upload#select")
  end

  it "provides accent-based active classes for drag-over feedback" do
    expect(described_class::DROP_ZONE_ACTIVE_CLASSES).to include("border-accent-500")
    expect(described_class::DROP_ZONE_ACTIVE_CLASSES).to include("bg-accent-50")
  end

  it "shows drop prompt text appropriate for single vs multiple" do
    single = described_class.new(name: "avatar")
    multi = described_class.new(name: "docs[]", multiple: true)

    expect(single.prompt_text).to eq("Drop file here or")
    expect(multi.prompt_text).to eq("Drop files here or")
  end
end
