# frozen_string_literal: true

module KeystoneUi
  class LookCheck
    class Error < StandardError; end

    def initialize(looks:, default:)
      @looks = looks
      @default = default
    end

    def call
      @looks.each do |name, path|
        raise Error, "The #{name} look's file #{path} does not exist." unless File.exist?(path)
      end
    end
  end
end
