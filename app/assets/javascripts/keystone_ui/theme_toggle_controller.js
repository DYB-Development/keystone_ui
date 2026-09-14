import { Controller } from "@hotwired/stimulus"

const COOKIE = "keystone_theme"
const ONE_YEAR = 60 * 60 * 24 * 365

export default class extends Controller {
  choose({ params: { mode } }) {
    const page = this.element.ownerDocument
    this.#showPressed(mode)

    if (mode === "system") {
      delete page.documentElement.dataset.theme
    } else {
      page.documentElement.dataset.theme = mode
    }
    page.cookie = `${COOKIE}=${mode}; path=/; max-age=${ONE_YEAR}; samesite=lax`
  }

  #showPressed(mode) {
    this.element.querySelectorAll("[data-theme-toggle-mode-param]").forEach((option) => {
      option.setAttribute("aria-pressed", String(option.dataset.themeToggleModeParam === mode))
    })
  }
}
