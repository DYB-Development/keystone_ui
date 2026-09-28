# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::PipelineComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  def test_exposes_title
    component = Keystone::Ui::PipelineComponent.new(
      title: "Order fulfilment",
      boxes: [ { label: "Placed" } ],
      links: []
    )

    assert_equal "Order fulfilment", component.title
  end

  def test_count_class_maps_emerald_accent_to_the_keystone_accent
    component = Keystone::Ui::PipelineComponent.new(title: "T", boxes: [], links: [])

    assert_includes component.count_class(:emerald), "text-accent-400"
  end

  def test_count_class_falls_back_to_muted_for_an_unknown_accent
    component = Keystone::Ui::PipelineComponent.new(title: "T", boxes: [], links: [])

    assert_includes component.count_class(nil), "text-surface-500"
  end

  def test_link_after_returns_the_connector_following_a_box
    link = { broken: false, url: "/links/toggle", params: { at: "ship" } }
    component = Keystone::Ui::PipelineComponent.new(
      title: "T",
      boxes: [ { label: "Placed" }, { label: "Shipped" } ],
      links: [ link ]
    )

    assert_equal link, component.link_after(0)
  end

  def test_link_classes_mark_a_broken_handoff_in_red
    component = Keystone::Ui::PipelineComponent.new(title: "T", boxes: [], links: [])

    assert_includes component.link_classes({ broken: true }), "text-red-500"
  end

  def test_link_classes_mark_a_healthy_handoff_with_the_accent
    component = Keystone::Ui::PipelineComponent.new(title: "T", boxes: [], links: [])

    assert_includes component.link_classes({ broken: false }), "text-accent-500"
  end

  def test_container_classes_render_the_ks_pipeline_class
    assert_includes Keystone::Ui::PipelineComponent::CONTAINER_CLASSES, "ks-pipeline"
  end

  def test_container_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::PipelineComponent::CONTAINER_CLASSES
  end

  def test_header_classes_render_the_ks_pipeline_header_class
    assert_includes Keystone::Ui::PipelineComponent::HEADER_CLASSES, "ks-pipeline-header"
  end

  def test_header_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::PipelineComponent::HEADER_CLASSES
  end

  def test_title_classes_render_the_ks_pipeline_title_class
    assert_includes Keystone::Ui::PipelineComponent::TITLE_CLASSES, "ks-pipeline-title"
  end

  def test_title_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::PipelineComponent::TITLE_CLASSES
  end

  def test_subtitle_classes_render_the_ks_pipeline_subtitle_class
    assert_includes Keystone::Ui::PipelineComponent::SUBTITLE_CLASSES, "ks-pipeline-subtitle"
  end

  def test_subtitle_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::PipelineComponent::SUBTITLE_CLASSES
  end

  def test_track_classes_render_the_ks_pipeline_track_class
    assert_includes Keystone::Ui::PipelineComponent::TRACK_CLASSES, "ks-pipeline-track"
  end

  def test_track_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::PipelineComponent::TRACK_CLASSES
  end
end
