# frozen_string_literal: true

require "test_helper"

class Keystone::ComponentLookGuardTest < Minitest::Test
  VISUAL_UTILITY = /\A-?(bg|text|border|rounded|shadow|ring|ring-offset|font|divide|p[xytblr]?|m[xytblr]?|gap|space-[xy])(-|\z)/
  NOT_A_LOOK_VALUE = /\A(text-(xs|sm|base|lg|\d?xl|left|center|right|nowrap|balance)|border-transparent|-?m[xytblr]?-(0|auto)|p[xytblr]?-0|font-(mono|normal))\z/

  def test_no_component_constant_holds_a_visual_utility
    assert_empty visual_utilities
  end

  private

  def visual_utilities
    Keystone::Safelist::COMPONENTS.flat_map do |component|
      (component.constants(false) - Keystone::Safelist::SKIP_CONSTANTS).flat_map do |name|
        class_tokens(component.const_get(name)).filter_map do |token|
          utility = token.split(":").last
          "#{component.name.split("::").last}::#{name} #{token}" if VISUAL_UTILITY.match?(utility) && !NOT_A_LOOK_VALUE.match?(utility)
        end
      end
    end
  end

  def class_tokens(value)
    case value
    when String then value.split
    when Hash then value.values.flat_map { |nested| class_tokens(nested) }
    else []
    end
  end
end
