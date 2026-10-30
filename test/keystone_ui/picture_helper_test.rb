# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/string/output_safety"
require_relative "../../app/helpers/keystone_ui_helper"

class KeystoneUi::PictureHelperTest < Minitest::Test
  class View
    include KeystoneUiHelper

    attr_reader :rendered

    def render(component)
      @rendered = component
    end
  end

  def test_renders_a_picture
    view = View.new

    view.ui_picture(src: "/pictures/eiffel.jpg", alt: "The Eiffel Tower")

    assert_instance_of Keystone::Ui::PictureComponent, view.rendered
  end
end
