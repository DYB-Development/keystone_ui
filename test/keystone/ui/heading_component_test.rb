# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::HeadingComponentTest < Minitest::Test
  def test_draws_a_heading_at_the_size_chosen
    assert_equal [ "ks-heading ks-heading-sm", "ks-heading ks-heading-md", "ks-heading ks-heading-lg" ],
      %i[sm md lg].map { |size| Keystone::Ui::HeadingComponent.new(text: "Work", size: size).classes }
  end
end
