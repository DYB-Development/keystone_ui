# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::FormPageComponentRenderTest < ViewComponent::TestCase
  def teardown
    KeystoneUi.reset_configuration!
  end

  def test_renders_the_title_as_the_page_heading
    page = render_form_page(title: "New Invoice", back_url: "/invoices")

    assert_equal "New Invoice", page.css("h1").text.strip
  end

  def test_shows_the_title_inside_the_page_container
    page = render_form_page(title: "New Invoice", back_url: "/invoices")

    assert_equal [ true ], page.css("h1").map { |heading| heading.ancestors("div.ks-page").any? }
  end

  def test_shows_a_desktop_link_back_to_the_back_url
    page = render_form_page(title: "New Invoice", back_url: "/invoices")

    assert_equal "/invoices", page.css("a.lg\\:inline-flex").attr("href")&.value
  end

  def test_shows_the_desktop_back_link_inside_the_page_container
    page = render_form_page(title: "New Invoice", back_url: "/invoices")

    assert_equal [ true ], page.css("a.lg\\:inline-flex").map { |link| link.ancestors("div.ks-page").any? }
  end

  def test_given_a_trail_shows_breadcrumbs_ending_with_the_title
    page = render_form_page(title: "New Invoice", back_url: "/invoices", trail: [ [ "Invoices", "/invoices" ] ])

    assert_equal "New Invoice", page.css("nav[aria-label=Breadcrumb] [aria-current=page]").text.strip
  end

  def test_given_a_trail_shows_the_breadcrumbs_inside_the_page_container
    page = render_form_page(title: "New Invoice", back_url: "/invoices", trail: [ [ "Invoices", "/invoices" ] ])

    assert_equal [ true ], page.css("nav[aria-label=Breadcrumb]").map { |nav| nav.ancestors("div.ks-page").any? }
  end

  def test_given_a_trail_leaves_out_the_desktop_back_link
    page = render_form_page(title: "New Invoice", back_url: "/invoices", trail: [ [ "Invoices", "/invoices" ] ])

    assert_empty page.css("a.lg\\:inline-flex")
  end

  def test_given_no_trail_shows_the_trail_the_app_supplies
    KeystoneUi.configure { |c| c.trail_supplier = ->(_view) { [ [ "Invoices", "/invoices" ] ] } }

    page = render_form_page(title: "New Invoice", back_url: "/invoices")

    assert_equal "New Invoice", page.css("nav[aria-label=Breadcrumb] [aria-current=page]").text.strip
  end

  def test_given_its_own_trail_does_not_ask_the_app_for_one
    KeystoneUi.configure { |c| c.trail_supplier = ->(_view) { [ [ "Supplied", "/supplied" ] ] } }

    page = render_form_page(title: "New Invoice", back_url: "/invoices", trail: [ [ "Invoices", "/invoices" ] ])

    assert_equal [ "/invoices" ], page.css("nav[aria-label=Breadcrumb] a").map { |link| link["href"] }
  end

  def test_given_no_back_link_goes_back_to_the_last_link_of_its_trail
    back_url = render_in_view_context do
      ui_form_page(title: "New Invoice", trail: [ [ "Billing", "/billing" ], [ "Invoices", "/invoices" ] ])
      content_for(:form_page_back_url)
    end

    assert_equal "/invoices", back_url.text.strip
  end

  def test_given_its_own_back_link_keeps_it_over_the_last_link_of_its_trail
    back_url = render_in_view_context do
      ui_form_page(title: "New Invoice", back_url: "/kinds", trail: [ [ "Invoices", "/invoices" ] ])
      content_for(:form_page_back_url)
    end

    assert_equal "/kinds", back_url.text.strip
  end

  def test_given_no_back_link_and_no_trail_raises_an_error_naming_the_page
    error = assert_raises(KeystoneUi::MissingBackLink) { render_form_page(title: "New Invoice") }

    assert_match(/New Invoice/, error.message)
  end

  def test_given_an_empty_trail_shows_no_back_link
    page = render_form_page(title: "Settings", trail: [])

    assert_empty page.css("a")
  end

  def test_given_a_trail_link_with_no_label_raises_an_error_naming_the_page
    KeystoneUi.configure { |c| c.trail_supplier = ->(_view) { [ [ nil, "/invoices" ] ] } }

    error = assert_raises(KeystoneUi::IncompleteTrail) { render_form_page(title: "New Invoice") }

    assert_match(/New Invoice/, error.message)
  end

  def test_given_a_trail_link_with_no_address_raises_an_error_naming_the_page
    KeystoneUi.configure { |c| c.trail_supplier = ->(_view) { [ [ "Invoices", nil ] ] } }

    error = assert_raises(KeystoneUi::IncompleteTrail) { render_form_page(title: "New Invoice", back_url: "/invoices") }

    assert_match(/New Invoice/, error.message)
  end

  private

  def render_form_page(**wrapper)
    render_in_view_context { safe_join([ ui_form_page(**wrapper), ui_page { "Body" } ]) }
  end
end
