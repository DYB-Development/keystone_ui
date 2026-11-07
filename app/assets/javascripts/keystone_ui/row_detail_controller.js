import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle(event) {
    const button = event.currentTarget.querySelector("[data-row-detail-target=toggle]")
    const detail = this.element.querySelector(`[id="${button.getAttribute("aria-controls")}"]`)

    button.setAttribute("aria-expanded", "true")
    detail.hidden = false
  }
}
