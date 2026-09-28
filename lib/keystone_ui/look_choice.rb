# frozen_string_literal: true

module KeystoneUi
  class LookChoice
    def initialize(looks:, default:, supplied: nil)
      @looks = looks
      @default = default
      @supplied = supplied
    end

    def name
      [ @supplied, @default ].find { |candidate| @looks.include?(candidate) }
    end

    def html_attributes
      name ? { "data-look" => name } : {}
    end
  end
end
