import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "option", "error"]
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
    if (this.menuTarget.classList.contains("hidden")) {
      this.menuTarget.classList.remove("hidden")
    } else {
      this.hideMenu()
    }
  }

  close(event) {
    if (!this.element.contains(event.target)) {
      this.hideMenu()
    }
  }

  hideMenu() {
    this.menuTarget.classList.add("hidden")
    if (!this.changed) return

    this.changed = false
    this.send()
  }

  mark(event) {
    const option = this.optionFor(event)
    option.querySelector("label").classList.toggle("ks-menu-option-hidden", !this.checkboxIn(option).checked)
    this.changed = true
  }

  optionFor(event) {
    return event.currentTarget.closest('[data-column-picker-target="option"]')
  }

  moveUp(event) {
    const option = this.optionFor(event)
    const previous = option.previousElementSibling
    if (!previous) return

    option.parentNode.insertBefore(option, previous)
    this.moved()
  }

  moveDown(event) {
    const option = this.optionFor(event)
    const next = option.nextElementSibling
    if (!next) return

    option.parentNode.insertBefore(next, option)
    this.moved()
  }

  moved() {
    this.changed = true
    const options = this.optionTargets
    options.forEach((option, index) => {
      option.querySelector('[data-action="click->column-picker#moveUp"]').disabled = index === 0
      option.querySelector('[data-action="click->column-picker#moveDown"]').disabled = index === options.length - 1
    })
  }

  columnOrder() {
    return this.optionTargets.map(option => this.checkboxIn(option).value)
  }

  hiddenColumns() {
    return this.optionTargets
      .map(option => this.checkboxIn(option))
      .filter(checkbox => !checkbox.checked)
      .map(checkbox => checkbox.value)
  }

  checkboxIn(option) {
    return option.querySelector("input[type=checkbox]")
  }

  send() {
    if (!this.hasSaveUrlValue) return

    const token = document.querySelector('meta[name="csrf-token"]')?.content
    fetch(this.saveUrlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token
      },
      body: JSON.stringify({ hidden_columns: this.hiddenColumns(), column_order: this.columnOrder() })
    }).then((response) => {
      if (!response.ok) return this.failed()

      Turbo.visit(window.location.href, { action: "replace" })
    })
  }

  failed() {
    this.errorTarget.classList.remove("hidden")
  }
}
