# frozen_string_literal: true

module KeystoneColorPalette
  class SettingsController < ApplicationController
    def show
      @templates = Templates.all
      @current_pref = current_preference
      @accents = ThemePreference::SUPPORTED_ACCENTS
      @surfaces = ThemePreference::SUPPORTED_SURFACES
    end

    def update
      pref = ThemePreference.find_or_initialize_by(
        owner_type: current_owner.class.name,
        owner_id: current_owner.id
      )

      if params[:template_name].present?
        pref.apply_template!(params[:template_name])
      else
        pref.template_name = nil
        pref.accent = params[:accent]
        pref.surface = params[:surface]
        pref.save!
      end

      session.delete(:keystone_palette)
      redirect_to settings_path, notice: "Color palette updated!"
    end

    private

    def current_owner
      send(KeystoneColorPalette.configuration.current_owner_method)
    end

    def current_preference
      ThemePreference.find_by(
        owner_type: current_owner.class.name,
        owner_id: current_owner.id
      )
    end
  end
end
