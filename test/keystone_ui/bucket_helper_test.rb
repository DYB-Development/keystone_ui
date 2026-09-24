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

  def test_renders_a_bucket_series_with_one_bucket_per_entry
    view = View.new

    view.ui_bucket_series(buckets: [ { goal: 600, actual: 450 }, { goal: 40, actual: 12 } ])

    assert_equal 2, view.rendered.bucket_components.size
  end
end
