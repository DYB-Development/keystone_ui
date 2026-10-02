import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "summary", "detail"]

  peek() {
    this.show(this.summaryTarget)
  }

  unpeek() {
    this.summaryTarget.classList.add("hidden")
  }

  toggle(event) {
    event.stopPropagation()
    const shown = this.hasDetailTarget ? this.detailTarget : this.summaryTarget
    shown.classList.contains("hidden") ? this.show(shown) : shown.classList.add("hidden")
  }

  hide(event) {
    if (this.hasDetailTarget && !this.element.contains(event.target)) this.detailTarget.classList.add("hidden")
  }

  close() {
    this.summaryTarget.classList.add("hidden")
    if (this.hasDetailTarget) this.detailTarget.classList.add("hidden")
  }

  show(shown) {
    Object.assign(shown.style, { position: "fixed", right: "auto" })
    shown.classList.remove("hidden")
    const button = this.buttonTarget.getBoundingClientRect()
    Object.assign(shown.style, {
      top: `${button.bottom}px`,
      left: `${Math.max(8, button.right - shown.offsetWidth)}px`
    })
  }
}
