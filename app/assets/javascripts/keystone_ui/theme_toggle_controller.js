import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle() {
    const page = this.element.ownerDocument
    page.documentElement.dataset.theme = page.documentElement.dataset.theme === "dark" ? "light" : "dark"
  }
}
