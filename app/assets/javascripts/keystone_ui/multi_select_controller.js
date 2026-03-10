import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "label"]
  static values = { label: String }

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

  updateLabel() {
    const checked = this.element.querySelectorAll("input[type=checkbox]:checked")
    if (checked.length === 0) {
      this.labelTarget.textContent = `All ${this.labelValue}`
    } else {
      this.labelTarget.textContent = `${checked.length} selected`
    }
  }
}
