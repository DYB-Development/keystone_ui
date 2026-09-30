import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "button"]

  toggle(event) {
    event.stopPropagation()
    this.menuTarget.classList.toggle("hidden")
    if (!this.menuTarget.classList.contains("hidden")) this.place()
  }

  hide(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
    }
  }

  close() {
    this.menuTarget.classList.add("hidden")
  }

  place() {
    const button = this.buttonTarget.getBoundingClientRect()
    Object.assign(this.menuTarget.style, {
      position: "fixed",
      top: `${button.bottom}px`,
      left: `${button.right - this.menuTarget.offsetWidth}px`,
      right: "auto"
    })
  }
}
