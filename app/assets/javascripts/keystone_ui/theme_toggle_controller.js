import { Controller } from "@hotwired/stimulus"

const COOKIE = "keystone_theme"
const ONE_YEAR = 60 * 60 * 24 * 365

export default class extends Controller {
  choose({ params: { mode } }) {
    const page = this.element.ownerDocument

    page.documentElement.dataset.theme = mode
    page.cookie = `${COOKIE}=${mode}; path=/; max-age=${ONE_YEAR}; samesite=lax`
  }
}
