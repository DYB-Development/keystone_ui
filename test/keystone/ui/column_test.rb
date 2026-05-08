# frozen_string_literal: true

require "test_helper"
require_relative "../../../app/components/keystone/ui/column"

class Keystone::Ui::ColumnTest < Minitest::Test
  def test_exposes_key_and_header_text
    column = Keystone::Ui::Column.new(:name, "Name")

    assert_equal :name, column.key
    assert_equal "Name", column.header_text
  end

  def test_defaults_mobile_hidden_to_false
    column = Keystone::Ui::Column.new(:name, "Name")
    assert_equal false, column.mobile_hidden?
  end

  def test_accepts_mobile_hidden_true
    column = Keystone::Ui::Column.new(:name, "Name", mobile_hidden: true)
    assert_equal true, column.mobile_hidden?
  end
end
