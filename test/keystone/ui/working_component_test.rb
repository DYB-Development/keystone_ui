# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::WorkingComponentTest < Minitest::Test
  def test_offers_the_working_under_a_quiet_summary_by_default
    assert_equal "How this is worked out", Keystone::Ui::WorkingComponent.new(groups: []).summary
  end
end
