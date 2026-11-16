# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/string/output_safety"
require_relative "../../app/helpers/keystone_ui_helper"

class KeystoneUi::ReviewCardHelperTest < Minitest::Test
  class View
    include KeystoneUiHelper

    attr_reader :rendered

    def render(component)
      @rendered = component
    end
  end

  def test_renders_a_review_card
    view = View.new

    view.ui_review_card(id: "variant A", title: "Fall catalog is here. 40 new pieces.")

    assert_instance_of Keystone::Ui::ReviewCardComponent, view.rendered
  end
end
