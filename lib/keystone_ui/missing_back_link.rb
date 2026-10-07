# frozen_string_literal: true

module KeystoneUi
  class MissingBackLink < StandardError
    def initialize(title)
      super(%(The page "#{title}" has no Back link. Pass back_url: or trail:, or supply a trail for it through config.trail_supplier. A nav tab's own page passes trail: [].))
    end
  end
end
