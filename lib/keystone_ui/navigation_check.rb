# frozen_string_literal: true

module KeystoneUi
  class NavigationCheck
    class Error < StandardError; end

    def initialize(groups:)
      @groups = groups
    end

    def call
      @groups.each do |group|
        group.tabs.each do |tab|
          raise Error, "The #{tab.key} tab has no label." if blank?(tab.label)
          raise Error, "The #{tab.key} tab has no link." if blank?(tab.href)
        end
      end
      nil
    end

    private

    def blank?(value)
      value.nil? || value.to_s.strip.empty?
    end
  end
end
