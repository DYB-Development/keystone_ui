import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "status", "announcer", "end", "reached", "inViewOnLoad"]
  static values = { seconds: Number, elapsed: Number, requireEnd: Boolean, waiting: String, ready: String }

  connect() {
    this.secondsLeft = Math.max(this.secondsValue - this.elapsedValue, 0)
    this.endReached = !this.requireEndValue
    if (this.secondsLeft > 0) this.timer = setInterval(() => this.tick(), 1000)
    this.attachEndReport()
    if (this.requireEndValue) this.watchEnd()
    this.update()
  }

  disconnect() {
    clearInterval(this.timer)
    this.observer?.disconnect()
  }

  attachEndReport() {
    this.reachedField = this.reachedTarget
    this.inViewOnLoadField = this.inViewOnLoadTarget
    this.reportEnd()
    this.buttonTarget.form?.append(this.reachedField, this.inViewOnLoadField)
  }

  reportEnd() {
    this.reachedField.value = String(this.endReached)
    this.inViewOnLoadField.value = String(Boolean(this.endInViewOnLoad))
  }

  watchEnd() {
    let first = true
    this.observer = new IntersectionObserver((entries) => {
      if (entries.some((entry) => entry.isIntersecting)) {
        this.endInViewOnLoad = first
        this.reachEnd()
      }
      first = false
    })
    this.observer.observe(this.endTarget)
  }

  reachEnd() {
    this.endReached = true
    this.observer.disconnect()
    this.reportEnd()
    this.update()
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
    const wasHeld = this.buttonTarget.getAttribute("aria-disabled") === "true"
    if (this.held) {
      this.buttonTarget.setAttribute("aria-disabled", "true")
      this.statusTarget.textContent = this.waitingValue.replace("{seconds}", this.secondsLeft)
    } else {
      this.buttonTarget.removeAttribute("aria-disabled")
      this.statusTarget.textContent = ""
      if (wasHeld) this.announcerTarget.textContent = this.readyValue
    }
  }
}
