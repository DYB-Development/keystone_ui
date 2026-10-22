import { Controller } from "@hotwired/stimulus"

const COOKIE = "keystone_theme"
const ONE_YEAR = 60 * 60 * 24 * 365

export default class extends Controller {
  toggle() {
    const page = this.element.ownerDocument
    const mode = page.documentElement.dataset.theme === "dark" ? "light" : "dark"

    page.documentElement.dataset.theme = mode
    page.cookie = `${COOKIE}=${mode}; path=/; max-age=${ONE_YEAR}; samesite=lax`
  }
}
