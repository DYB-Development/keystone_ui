import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]
  static values = { seconds: Number, elapsed: Number, requireEnd: Boolean }

  connect() {
    this.secondsLeft = Math.max(this.secondsValue - this.elapsedValue, 0)
    this.update()
  }

  disconnect() {}

  update() {
    if (this.secondsLeft > 0) {
      this.buttonTarget.setAttribute("aria-disabled", "true")
    } else {
      this.buttonTarget.removeAttribute("aria-disabled")
    }
  }
}
