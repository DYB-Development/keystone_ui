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
    if (event.target === document.activeElement && event.detail.attributeName === "value") event.preventDefault()
  }

  remember() {
    const active = document.activeElement
    this.focusedId = this.element.contains(active) ? active.id : null
    this.selection = [active?.selectionStart, active?.selectionEnd]
  }

  restore() {
    if (!this.focusedId || document.activeElement?.id === this.focusedId) return

    const field = document.getElementById(this.focusedId)
    field?.focus()
    if (Number.isInteger(this.selection[0])) field?.setSelectionRange(...this.selection)
  }

  submitNow() {
    clearTimeout(this.timer)
    this.timer = null
    this.submit()
  }
}
