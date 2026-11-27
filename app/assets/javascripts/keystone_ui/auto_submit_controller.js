import { Controller } from "@hotwired/stimulus"

const TYPED_FIELDS = ["text", "number", "search", "email", "tel", "url"]

export default class extends Controller {
  static values = { delay: { type: Number, default: 500 } }

  disconnect() {
    clearTimeout(this.timer)
    this.timer = null
  }

  submit() {
    this.element.requestSubmit()
  }

  changed(event) {
    if (TYPED_FIELDS.includes(event.target.type) && !this.timer) return

    this.submitNow()
  }

  typed(event) {
    if (!TYPED_FIELDS.includes(event.target.type)) return

    clearTimeout(this.timer)
    this.timer = setTimeout(() => this.submitNow(), this.delayValue)
  }

  keep(event) {
    event.preventDefault()
  }

  submitNow() {
    clearTimeout(this.timer)
    this.timer = null
    this.submit()
  }
}
