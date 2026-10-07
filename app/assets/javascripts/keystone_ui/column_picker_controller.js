import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "option"]
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
      this.hideMenu()
    }
  }

  hideMenu() {
    this.menuTarget.classList.add("hidden")
    if (!this.changed) return

    this.changed = false
    this.send(this.columnOrder())
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
    this.changed = true
  }

  moveDown(event) {
    this.move(event, 1)
  }

  move(event, step) {
    const order = this.columnOrder()
    const index = this.optionTargets.indexOf(this.optionFor(event))
    const [key] = order.splice(index, 1)
    order.splice(index + step, 0, key)
    this.send(order)
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

  send(columnOrder) {
    if (!this.hasSaveUrlValue) return

    const token = document.querySelector('meta[name="csrf-token"]')?.content
    fetch(this.saveUrlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token
      },
      body: JSON.stringify({ hidden_columns: this.hiddenColumns(), column_order: columnOrder })
    }).then(() => {
      Turbo.visit(window.location.href, { action: "replace" })
    })
  }
}
