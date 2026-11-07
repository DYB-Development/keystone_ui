import { Controller } from "@hotwired/stimulus"

const CONTROLS = "a, button, input, select, textarea, label, summary"
const KEPT_ATTRIBUTES = ["hidden", "aria-expanded"]

export default class extends Controller {
  toggle(event) {
    const button = event.currentTarget.querySelector("[data-row-detail-target=toggle]")
    const control = event.target.closest(CONTROLS)
    if (control && control !== button) return

    const detail = this.element.querySelector(`[id="${button.getAttribute("aria-controls")}"]`)
    const open = button.getAttribute("aria-expanded") !== "true"

    button.setAttribute("aria-expanded", String(open))
    detail.hidden = !open
  }

  keep(event) {
    if (!event.target.getAttribute("data-row-detail-target")) return

    if (KEPT_ATTRIBUTES.includes(event.detail.attributeName)) event.preventDefault()
  }
}
