import { Controller } from "@hotwired/stimulus"

const TYPED_FIELDS = ["text", "number", "search", "email", "tel", "url"]
const sending = new Set()
const waiting = []

export default class extends Controller {
  static values = { delay: { type: Number, default: 500 } }

  disconnect() {
    clearTimeout(this.timer)
    this.timer = null
    if (waiting.includes(this)) waiting.splice(waiting.indexOf(this), 1)
    if (sending.has(this) && !this.answering) this.release()
  }

  submit() {
    if (sending.size > 0) {
      if (!waiting.includes(this)) waiting.push(this)
      return
    }

    sending.add(this)
    this.turboStarted = false
    this.element.requestSubmit()
    setTimeout(() => this.releaseUnstarted())
  }

  releaseUnstarted() {
    if (!this.turboStarted && sending.has(this)) this.release()
  }

  started() {
    this.turboStarted = true
    sending.add(this)
  }

  async finished(event) {
    this.answering = true
    try {
      await this.answerDrawn(event.detail.fetchResponse)
    } finally {
      this.release()
    }
  }

  release() {
    this.answering = false
    sending.delete(this)
    if (sending.size > 0) return

    waiting.shift()?.submit()
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

  async answerDrawn(fetchResponse) {
    await fetchResponse?.responseHTML
    await new Promise((resolve) => setTimeout(resolve))
    await Promise.allSettled(Array.from(document.querySelectorAll("turbo-stream"), (stream) => stream.render()))
  }

  submitNow() {
    clearTimeout(this.timer)
    this.timer = null
    this.submit()
  }
}
