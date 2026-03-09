# frozen_string_literal: true

class CreateKeystoneThemePreferences < ActiveRecord::Migration[7.0]
  def change
    create_table :keystone_theme_preferences do |t|
      t.string :owner_type, null: false
      t.bigint :owner_id, null: false
      t.string :template_name
      t.string :accent, null: false, default: "blue"
      t.string :surface, null: false, default: "zinc"
      t.timestamps
    end

    add_index :keystone_theme_preferences, [:owner_type, :owner_id], unique: true, name: "idx_keystone_theme_prefs_owner"
  end
end
