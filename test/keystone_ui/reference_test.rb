# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/keystone_ui/reference"

class KeystoneUiReferenceTest < Minitest::Test
  def test_content_includes_a_documented_helper
    assert_includes KeystoneUi::Reference.content, "ui_button"
  end

  def test_content_documents_the_funnel_helper
    assert_includes KeystoneUi::Reference.content, "ui_funnel"
  end

  def test_content_documents_the_pipeline_helper
    assert_includes KeystoneUi::Reference.content, "ui_pipeline"
  end

  def test_content_documents_the_multi_select_signature
    assert_includes KeystoneUi::Reference.content, "ui_multi_select(name:, label:, options:"
  end

  def test_content_documents_the_index_page_recipe
    assert_includes KeystoneUi::Reference.content, "Index page"
  end

  def test_content_carries_the_canonical_required_sections
    content = KeystoneUi::Reference.content
    assert_includes content, "### Interface"
    assert_includes content, "### Recipe"
    assert_includes content, "### Install"
    assert_includes content, "### Conventions"
  end
end
