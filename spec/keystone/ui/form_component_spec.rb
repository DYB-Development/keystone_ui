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
end
