import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "summary", "detail"]

  peek() {
    this.summaryTarget.classList.remove("hidden")
    this.place(this.summaryTarget)
  }

  unpeek() {
    this.summaryTarget.classList.add("hidden")
  }

  toggle(event) {
    event.stopPropagation()
    const shown = this.hasDetailTarget ? this.detailTarget : this.summaryTarget
    shown.classList.toggle("hidden")
    if (!shown.classList.contains("hidden")) this.place(shown)
  }

  hide(event) {
    if (this.hasDetailTarget && !this.element.contains(event.target)) this.detailTarget.classList.add("hidden")
  }

  place(shown) {
    const button = this.buttonTarget.getBoundingClientRect()
    Object.assign(shown.style, {
      position: "fixed",
      top: `${button.bottom}px`,
      left: `${button.right - shown.offsetWidth}px`,
      right: "auto"
    })
  }
}
