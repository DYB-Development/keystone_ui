# frozen_string_literal: true

module KeystoneUiHelper
  def ui_accordion(**args)
    render Keystone::Ui::AccordionComponent.new(**args)
  end

  def ui_tab_switcher(**args, &block)
    render Keystone::Ui::TabSwitcherComponent.new(**args), &block
  end

  def ui_stat_card(**args)
    render Keystone::Ui::StatCardComponent.new(**args)
  end

  def ui_chart_card(**args, &block)
    render Keystone::Ui::ChartCardComponent.new(**args), &block
  end

  def ui_line_chart(**args)
    render Keystone::Ui::LineChartComponent.new(**args)
  end

  def ui_cta_banner(**args, &block)
    render Keystone::Ui::CtaBannerComponent.new(**args), &block
  end

  def ui_feature_grid(**args)
    render Keystone::Ui::FeatureGridComponent.new(**args)
  end

  def ui_hero(**args, &block)
    render Keystone::Ui::HeroComponent.new(**args), &block
  end

  def ui_modal(**args, &block)
    render Keystone::Ui::ModalComponent.new(**args), &block
  end

  def ui_badge(**args)
    render Keystone::Ui::BadgeComponent.new(**args)
  end

  def ui_copy_button(**args)
    render Keystone::Ui::CopyButtonComponent.new(**args)
  end

  def ui_card(**args)
    render Keystone::Ui::CardComponent.new(**args)
  end

  def ui_button(**args)
    render Keystone::Ui::ButtonComponent.new(**args)
  end

  def ui_data_table(**args, &block)
    render Keystone::Ui::DataTableComponent.new(**args), &block
  end

  def ui_page(**args, &block)
    render Keystone::Ui::PageComponent.new(**args), &block
  end

  def ui_section(**args, &block)
    render Keystone::Ui::SectionComponent.new(**args), &block
  end

  def ui_grid(**args, &block)
    render Keystone::Ui::GridComponent.new(**args), &block
  end

  def ui_panel(**args, &block)
    render Keystone::Ui::PanelComponent.new(**args), &block
  end

  def ui_card_link(**args, &block)
    render Keystone::Ui::CardLinkComponent.new(**args), &block
  end

  def ui_input(**args)
    render Keystone::Ui::InputComponent.new(**args)
  end

  def ui_textarea(**args)
    render Keystone::Ui::TextareaComponent.new(**args)
  end

  def ui_select(**args)
    render Keystone::Ui::SelectComponent.new(**args)
  end

  def ui_form_field(**args)
    render Keystone::Ui::FormFieldComponent.new(**args)
  end

  def ui_page_header(**args, &block)
    render Keystone::Ui::PageHeaderComponent.new(**args), &block
  end

  def ui_alert(**args)
    render Keystone::Ui::AlertComponent.new(**args)
  end

  def ui_form_page(**args)
    render Keystone::Ui::FormPageComponent.new(**args)
  end

  def ui_show_page(**args)
    render Keystone::Ui::ShowPageComponent.new(**args)
  end

  def ui_mobile_header(**args)
    render Keystone::Ui::MobileHeaderComponent.new(**args)
  end

  def ui_mobile_actions(**args, &block)
    render Keystone::Ui::MobileActionsComponent.new(**args), &block
  end

  def ui_navbar(**args, &block)
    render Keystone::Ui::NavbarComponent.new(**args), &block
  end

  def ui_nav_item(**args)
    render Keystone::Ui::NavItemComponent.new(**args)
  end

  def ui_nav_dropdown(**args, &block)
    render Keystone::Ui::NavDropdownComponent.new(**args), &block
  end

  def ui_bottom_nav(**args, &block)
    render Keystone::Ui::BottomNavComponent.new(**args), &block
  end

  def ui_bottom_nav_item(**args)
    render Keystone::Ui::BottomNavItemComponent.new(**args)
  end

  def ui_option_card(**args, &block)
    render Keystone::Ui::OptionCardComponent.new(**args), &block
  end

  def ui_settings_link(**args)
    render Keystone::Ui::SettingsLinkComponent.new(**args)
  end

  def ui_color_picker(**args)
    render Keystone::Ui::ColorPickerComponent.new(**args)
  end

  def ui_multi_select(**args)
    render Keystone::Ui::MultiSelectComponent.new(**args)
  end

  def ui_swipe_deck(**args, &block)
    render Keystone::Ui::SwipeDeckComponent.new(**args), &block
  end

  def ui_column_picker(**args)
    render Keystone::Ui::ColumnPickerComponent.new(**args)
  end

  def ui_form(**args, &block)
    render Keystone::Ui::FormComponent.new(**args), &block
  end

  def ui_file_upload(**args)
    render Keystone::Ui::FileUploadComponent.new(**args)
  end
end
