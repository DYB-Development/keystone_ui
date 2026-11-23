import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "status"]
  static values = { seconds: Number, elapsed: Number, requireEnd: Boolean, waiting: String }

  connect() {
    this.secondsLeft = Math.max(this.secondsValue - this.elapsedValue, 0)
    this.endReached = !this.requireEndValue
    if (this.secondsLeft > 0) this.timer = setInterval(() => this.tick(), 1000)
    this.update()
  }

  disconnect() {
    clearInterval(this.timer)
  }

  tick() {
    this.secondsLeft -= 1
    if (this.secondsLeft <= 0) clearInterval(this.timer)
    this.update()
  }

  get held() {
    return this.secondsLeft > 0 || !this.endReached
  }

  update() {
    if (this.held) {
      this.buttonTarget.setAttribute("aria-disabled", "true")
      this.statusTarget.textContent = this.waitingValue.replace("{seconds}", this.secondsLeft)
    } else {
      this.buttonTarget.removeAttribute("aria-disabled")
      this.statusTarget.textContent = ""
    }
  }
}
