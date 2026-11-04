# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/string/output_safety"
require_relative "../../app/helpers/keystone_ui_helper"

class KeystoneUi::SortableListHelperTest < Minitest::Test
  class View
    include KeystoneUiHelper

    attr_reader :rendered

    def render(component)
      @rendered = component
    end
  end

  def test_renders_a_sortable_list
    view = View.new

    view.ui_sortable_list(name: "order[]", label: "Tied players", rows: [])

    assert_instance_of Keystone::Ui::SortableListComponent, view.rendered
  end
end
