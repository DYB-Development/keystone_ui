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
        raise Error, "The #{name} look's file #{path} sets no --ks- variables under :root[data-look=\"#{name}\"]." unless sets_variables?(name, path)
      end
    end

    private

    def sets_variables?(name, path)
      File.read(path).match?(/\[data-look=["']?#{Regexp.escape(name)}["']?\][^{]*\{[^}]*--ks-/)
    end
  end
end
