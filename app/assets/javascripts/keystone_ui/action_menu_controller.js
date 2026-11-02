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

  follow() {
    if (!this.menuTarget.classList.contains("hidden")) this.place()
  }

  place() {
    const button = this.buttonTarget.getBoundingClientRect()
    const screenHeight = this.element.ownerDocument.documentElement.clientHeight
    const roomBelow = button.bottom + this.menuTarget.offsetHeight <= screenHeight
    Object.assign(this.menuTarget.style, {
      position: "fixed",
      top: `${roomBelow ? button.bottom : Math.max(0, button.top - this.menuTarget.offsetHeight)}px`,
      left: `${button.right - this.menuTarget.offsetWidth}px`,
      right: "auto"
    })
  }
}
