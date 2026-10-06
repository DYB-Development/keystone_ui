# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::FigureComponentTest < Minitest::Test
  def test_shows_a_figure_in_the_colour_of_its_tone
    assert_equal [ "ks-figure", "ks-figure ks-tone-success", "ks-figure ks-tone-danger" ],
      %i[neutral success danger].map { |tone| Keystone::Ui::FigureComponent.new(text: "$1.00", tone: tone).classes }
  end
end
