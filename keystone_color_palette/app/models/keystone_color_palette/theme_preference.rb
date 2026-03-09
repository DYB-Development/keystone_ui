# frozen_string_literal: true

module KeystoneColorPalette
  class ThemePreference < ActiveRecord::Base
    self.table_name = "keystone_theme_preferences"

    SUPPORTED_ACCENTS = %w[blue emerald cyan indigo violet rose].freeze
    SUPPORTED_SURFACES = %w[zinc slate gray neutral stone].freeze

    belongs_to :owner, polymorphic: true

    validates :accent, inclusion: { in: SUPPORTED_ACCENTS }
    validates :surface, inclusion: { in: SUPPORTED_SURFACES }
    validates :template_name, inclusion: { in: KeystoneColorPalette::Templates.names.map(&:to_s), allow_nil: true }
    validates :owner_id, uniqueness: { scope: :owner_type }

    def apply_template!(name)
      template = KeystoneColorPalette::Templates[name]
      self.template_name = name.to_s
      self.accent = template[:accent].to_s
      self.surface = template[:surface].to_s
      save!
    end

    def accent_sym
      accent.to_sym
    end

    def surface_sym
      surface.to_sym
    end
  end
end
