# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/string/output_safety"
require_relative "../../app/helpers/keystone_ui_helper"

class KeystoneUi::BucketHelperTest < Minitest::Test
  class View
    include KeystoneUiHelper

    attr_reader :rendered

    def render(component)
      @rendered = component
    end
  end

  def test_renders_a_bucket_with_the_given_goal
    view = View.new

    view.ui_bucket(goal: 30_000, actual: 9_000)

    assert_equal 30_000, view.rendered.goal
  end
end
