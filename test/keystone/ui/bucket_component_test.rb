# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::BucketComponentTest < Minitest::Test
  def test_percent_is_the_share_of_the_goal_reached
    component = Keystone::Ui::BucketComponent.new(goal: 30_000, actual: 9_000)

    assert_equal 30, component.percent
  end

  def test_zero_goal_yields_zero_percent
    component = Keystone::Ui::BucketComponent.new(goal: 0, actual: 50)

    assert_equal 0, component.percent
  end
end
