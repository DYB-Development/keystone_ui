# frozen_string_literal: true

module KeystoneUi
  class Current < ActiveSupport::CurrentAttributes
    attribute :accent_override, :surface_override
  end
end
