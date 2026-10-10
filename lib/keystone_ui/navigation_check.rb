# frozen_string_literal: true

module KeystoneUi
  class NavigationCheck
    class Error < StandardError; end

    def initialize(groups:)
      @groups = groups
    end

    def call
      @groups.each do |group|
        raise Error, "The #{group.label} navigation group has no tabs." if group.tabs.empty?
      end
      tabs.each do |tab|
        raise Error, "The #{tab.key} tab has no label." if blank?(tab.label)
        raise Error, "The #{tab.key} tab has no link." if blank?(tab.href)
      end
      raise Error, "More than one navigation tab has the key #{shared_key}." if shared_key
      nil
    end

    private

    def tabs
      @groups.flat_map(&:tabs)
    end

    def shared_key
      tabs.map(&:key).tally.find { |_key, count| count > 1 }&.first
    end

    def blank?(value)
      value.nil? || value.to_s.strip.empty?
    end
  end
end
