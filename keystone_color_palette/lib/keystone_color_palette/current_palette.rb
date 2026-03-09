# frozen_string_literal: true

require "active_support/concern"

module KeystoneColorPalette
  module CurrentPalette
    extend ActiveSupport::Concern

    included do
      before_action :apply_keystone_palette
    end

    private

    def apply_keystone_palette
      owner = send(KeystoneColorPalette.configuration.current_owner_method) rescue nil
      return unless owner

      palette = load_palette_from_session_or_db(owner)
      return unless palette

      KeystoneUi::Current.accent_override = palette[:accent].to_sym
      KeystoneUi::Current.surface_override = palette[:surface].to_sym
    end

    def load_palette_from_session_or_db(owner)
      cached = session[:keystone_palette]
      return cached if cached

      pref = KeystoneColorPalette::ThemePreference.find_by(
        owner_type: owner.class.name,
        owner_id: owner.id
      )
      return unless pref

      palette = { accent: pref.accent, surface: pref.surface }
      session[:keystone_palette] = palette
      palette
    end
  end
end
