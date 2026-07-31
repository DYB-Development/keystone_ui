# Keystone UI Cleanup Plan

## 1. Extract inline CSS classes to constants (safelist fix) — DONE

Extracted all inline CSS strings to frozen constants across 11 components:
- `navbar_component` — NAV_BASE, NAV_STICKY, MOBILE_LEFT_CLASSES, LOGO_CLASSES, MOBILE_CENTER_CLASSES, DESKTOP_LINKS_CLASSES, MOBILE_RIGHT_CLASSES
- `mobile_header_component` — WRAPPER_CLASSES, SUBTITLE_CLASSES
- `form_page_component` — DESKTOP_WRAPPER_CLASSES
- `mobile_actions_component` — WRAPPER_CLASSES
- `nav_dropdown_component` — WRAPPER_CLASSES, MENU_CLASSES, ACTIVE_CLASS
- `bottom_nav_item_component` — ITEM_BASE, ACTIVE_CLASS, LABEL_CLASSES
- `nav_item_component` — ACTIVE_CLASS
- `card_link_component` — BASE_CLASSES, SHADOW_CLASS
- `panel_component` — BASE_CLASSES, SHADOW_CLASS
- `section_component` — HEADER_CLASSES, TITLE_CLASSES, SUBTITLE_CLASSES, ACTION_CLASSES
- `alert_component` — OUTER_CLASSES, INNER_CLASSES, MESSAGE_WITH_TITLE_CLASSES

Added ELLIPSIS_ICON, BACK_ICON, CARET_ICON to SKIP_CONSTANTS (SVG, not CSS).

## 2. Clean up `NON_CONSTANT_CLASSES` — DONE

Removed entries now covered by constants (section_component, card_link_component, alert_component entries). Kept data_table inline strings that are still in ERB templates.

## 3. Update CI Ruby matrix — DONE

- CI: `["3.0", "3.1", "3.2", "3.3"]` → `["3.1", "3.2", "3.3", "3.4"]`
- Gemspec: `>= 3.0.0` → `>= 3.1.0`

## 4. Update CLAUDE.md — DONE

Added documentation for all navigation/page components and the safelist constant convention.

## 5. Remove legacy rake tasks (optional) — DONE

`keystone:inject_source` and `keystone:clean_source` removed. They rewrote the `/* keystone:source */` marker that the install generator now strips as legacy, and no consuming app referenced them.
