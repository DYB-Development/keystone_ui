# frozen_string_literal: true

KeystoneColorPalette::Engine.routes.draw do
  resource :settings, only: [:show, :update], controller: "settings"
end
