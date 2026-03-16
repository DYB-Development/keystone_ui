import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]
  static values = { saveUrl: String }

  connect() {
    this._close = this.close.bind(this)
    document.addEventListener("click", this._close)
  }

  disconnect() {
    document.removeEventListener("click", this._close)
  }

  toggle(event) {
    event.stopPropagation()
    this.menuTarget.classList.toggle("hidden")
  }

  close(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
    }
  }

  save() {
    const allCheckboxes = this.element.querySelectorAll("input[type=checkbox]")
    const hiddenColumns = Array.from(allCheckboxes)
      .filter(cb => !cb.checked)
      .map(cb => cb.value)

    if (this.hasSaveUrlValue) {
      const token = document.querySelector('meta[name="csrf-token"]')?.content
      fetch(this.saveUrlValue, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": token
        },
        body: JSON.stringify({ hidden_columns: hiddenColumns })
      }).then(() => {
        Turbo.visit(window.location.href, { action: "replace" })
      })
    }
  }
}
