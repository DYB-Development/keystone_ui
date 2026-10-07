# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::ShowPageComponentRenderTest < ViewComponent::TestCase
  def teardown
    KeystoneUi.reset_configuration!
  end

  def test_shows_a_desktop_link_back_to_the_back_url
    page = render_show_page(title: "Invoice #42", back_url: "/invoices")

    assert_equal "/invoices", page.css("a.lg\\:inline-flex").attr("href")&.value
  end

  def test_shows_the_desktop_back_link_inside_the_page_container
    page = render_show_page(title: "Invoice #42", back_url: "/invoices")

    assert_equal [ true ], page.css("a.lg\\:inline-flex").map { |link| link.ancestors("div.ks-page").any? }
  end

  def test_given_a_trail_shows_breadcrumbs_ending_with_the_title
    page = render_show_page(title: "Invoice #42", back_url: "/invoices", trail: [ [ "Invoices", "/invoices" ] ])

    assert_equal "Invoice #42", page.css("nav[aria-label=Breadcrumb] [aria-current=page]").text.strip
  end

  def test_given_a_trail_shows_the_breadcrumbs_inside_the_page_container
    page = render_show_page(title: "Invoice #42", back_url: "/invoices", trail: [ [ "Invoices", "/invoices" ] ])

    assert_equal [ true ], page.css("nav[aria-label=Breadcrumb]").map { |nav| nav.ancestors("div.ks-page").any? }
  end

  def test_given_a_trail_leaves_out_the_desktop_back_link
    page = render_show_page(title: "Invoice #42", back_url: "/invoices", trail: [ [ "Invoices", "/invoices" ] ])

    assert_empty page.css("a.lg\\:inline-flex")
  end

  def test_given_no_trail_shows_the_trail_the_app_supplies
    KeystoneUi.configure { |c| c.trail_supplier = ->(_view) { [ [ "Invoices", "/invoices" ] ] } }

    page = render_show_page(title: "Invoice #42", back_url: "/invoices")

    assert_equal "Invoice #42", page.css("nav[aria-label=Breadcrumb] [aria-current=page]").text.strip
  end

  def test_given_its_own_trail_does_not_ask_the_app_for_one
    KeystoneUi.configure { |c| c.trail_supplier = ->(_view) { [ [ "Supplied", "/supplied" ] ] } }

    page = render_show_page(title: "Invoice #42", back_url: "/invoices", trail: [ [ "Invoices", "/invoices" ] ])

    assert_equal [ "/invoices" ], page.css("nav[aria-label=Breadcrumb] a").map { |link| link["href"] }
  end

  def test_given_no_back_link_goes_back_to_the_last_link_of_its_trail
    back_url = render_in_view_context do
      ui_show_page(title: "Invoice #42", trail: [ [ "Billing", "/billing" ], [ "Invoices", "/invoices" ] ])
      content_for(:show_page_back_url)
    end

    assert_equal "/invoices", back_url.text.strip
  end

  def test_given_its_own_back_link_keeps_it_over_the_last_link_of_its_trail
    back_url = render_in_view_context do
      ui_show_page(title: "Invoice #42", back_url: "/kinds", trail: [ [ "Invoices", "/invoices" ] ])
      content_for(:show_page_back_url)
    end

    assert_equal "/kinds", back_url.text.strip
  end

  def test_given_no_back_link_and_no_trail_raises_an_error_naming_the_page
    error = assert_raises(KeystoneUi::MissingBackLink) { render_show_page(title: "Invoice #42") }

    assert_match(/Invoice #42/, error.message)
  end

  def test_given_an_empty_trail_shows_no_back_link
    page = render_show_page(title: "Invoices", trail: [])

    assert_empty page.css("a")
  end

  def test_given_an_empty_trail_shows_no_breadcrumbs
    page = render_show_page(title: "Invoices", trail: [])

    assert_empty page.css("nav[aria-label=Breadcrumb]")
  end

  def test_given_a_trail_link_with_no_label_raises_an_error_naming_the_page
    KeystoneUi.configure { |c| c.trail_supplier = ->(_view) { [ [ nil, "/invoices" ] ] } }

    error = assert_raises(KeystoneUi::IncompleteTrail) { render_show_page(title: "Invoice #42") }

    assert_match(/Invoice #42/, error.message)
  end

  private

  def render_show_page(**wrapper)
    render_in_view_context { safe_join([ ui_show_page(**wrapper), ui_page { "Body" } ]) }
  end
end
