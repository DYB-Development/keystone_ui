import { Controller } from "@hotwired/stimulus"

const TYPED_FIELDS = ["text", "number", "search", "email", "tel", "url"]

export default class extends Controller {
  static values = { delay: { type: Number, default: 500 } }

  submit() {
    this.element.requestSubmit()
  }

  changed(event) {
    if (TYPED_FIELDS.includes(event.target.type)) return

    this.submit()
  }

  typed() {
    clearTimeout(this.timer)
    this.timer = setTimeout(() => this.submit(), this.delayValue)
  }
}
