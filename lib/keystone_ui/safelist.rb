# frozen_string_literal: true

module Keystone
  module Safelist
    # All component classes to scan for Tailwind CSS classes.
    # The safelist_spec verifies this list matches Keystone::Ui components.
    COMPONENTS = [
      Keystone::Ui::AccordionComponent,
      Keystone::Ui::TabSwitcherComponent,
      Keystone::Ui::StatCardComponent,
      Keystone::Ui::ChartCardComponent,
      Keystone::Ui::CtaBannerComponent,
      Keystone::Ui::FeatureGridComponent,
      Keystone::Ui::HeroComponent,
      Keystone::Ui::ModalComponent,
      Keystone::Ui::SelectComponent,
      Keystone::Ui::BadgeComponent,
      Keystone::Ui::CopyButtonComponent,
      Keystone::Ui::CardComponent,
      Keystone::Ui::ButtonComponent,
      Keystone::Ui::DataTableComponent,
      Keystone::Ui::PageComponent,
      Keystone::Ui::SectionComponent,
      Keystone::Ui::GridComponent,
      Keystone::Ui::PanelComponent,
      Keystone::Ui::CardLinkComponent,
      Keystone::Ui::InputComponent,
      Keystone::Ui::TextareaComponent,
      Keystone::Ui::FormFieldComponent,
      Keystone::Ui::PageHeaderComponent,
      Keystone::Ui::AlertComponent,
      Keystone::Ui::NavDropdownComponent,
      Keystone::Ui::NavItemComponent,
      Keystone::Ui::BottomNavItemComponent,
      Keystone::Ui::NavbarComponent,
      Keystone::Ui::BottomNavComponent,
      Keystone::Ui::SettingsLinkComponent,
      Keystone::Ui::FormPageComponent,
      Keystone::Ui::MobileActionsComponent,
      Keystone::Ui::MobileHeaderComponent,
      Keystone::Ui::ShowPageComponent,
      Keystone::Ui::OptionCardComponent,
      Keystone::Ui::ColorPickerComponent,
      Keystone::Ui::MultiSelectComponent,
      Keystone::Ui::SwipeDeckComponent
    ].freeze

    # Constants that hold non-CSS values (e.g. HTML input type maps)
    SKIP_CONSTANTS = %i[TYPE_MAP ELLIPSIS_ICON BACK_ICON CARET_ICON CLOSE_ICON COPY_ICON SORT_ASC_ICON SORT_DESC_ICON SORT_NEUTRAL_ICON].freeze

    # Classes used in Ruby methods or ERB templates, not in frozen constants.
    # These cannot be auto-extracted and must be listed manually.
    # The safelist_spec ensures every entry here appears in SAFELIST.
    NON_CONSTANT_CLASSES = %w[
      grid
      mx-auto
      overflow-hidden rounded-lg border border-gray-200 shadow-sm
      dark:border-zinc-700 dark:shadow-none
      relative min-w-full divide-y divide-gray-300 dark:divide-white/15
      bg-gray-50 dark:bg-gray-800/75
      divide-gray-200 bg-white dark:divide-white/10 dark:bg-gray-800/50
      px-3 py-4 text-sm text-gray-500 dark:text-gray-400
    ].freeze

    def self.extract_classes_from_hash(hash, classes)
      hash.each_value do |v|
        case v
        when String then classes.concat(v.split)
        when Hash then extract_classes_from_hash(v, classes)
        end
      end
    end

    def self.generate
      classes = []

      COMPONENTS.each do |klass|
        klass.constants(false).each do |const_name|
          next if SKIP_CONSTANTS.include?(const_name)

          value = klass.const_get(const_name)
          case value
          when String then classes.concat(value.split)
          when Hash then extract_classes_from_hash(value, classes)
          end
        end
      end

      classes.concat(NON_CONSTANT_CLASSES)

      classes.uniq.sort.join(" ")
    end
  end

  SAFELIST = Safelist.generate
end
