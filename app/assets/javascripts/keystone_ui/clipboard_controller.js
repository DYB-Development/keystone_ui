import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    successMessage: { type: String, default: "Copied!" },
    errorMessage: { type: String, default: "Failed!" }
  }

  async copy() {
    const text = this.element.dataset.clipboardText
    try {
      await navigator.clipboard.writeText(text)
      this.flash(this.successMessageValue)
    } catch {
      this.flash(this.errorMessageValue)
    }
  }

  flash(message) {
    const label = this.element.querySelector("span") || this.element.lastChild
    const original = label.textContent
    label.textContent = message
    setTimeout(() => { label.textContent = original }, 1500)
  }
}
