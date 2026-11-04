import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["row", "control", "status"]

  connect() {
    this.controlTargets.forEach((control) => { control.hidden = false })
  }

  moveUp({ currentTarget }) {
    const row = this.rowHolding(currentTarget)
    const previous = row.previousElementSibling
    if (previous) row.after(previous)
    this.announce(row)
  }

  moveDown({ currentTarget }) {
    const row = this.rowHolding(currentTarget)
    const next = row.nextElementSibling
    if (next) row.before(next)
    this.announce(row)
  }

  grab({ currentTarget, pointerId }) {
    currentTarget.setPointerCapture(pointerId)
    this.dragged = this.rowHolding(currentTarget)
    this.startingIndex = this.rowTargets.indexOf(this.dragged)
  }

  drag({ clientY }) {
    const row = this.dragged
    if (!row) return
    while (row.nextElementSibling && clientY > this.middleOf(row.nextElementSibling)) row.before(row.nextElementSibling)
    while (row.previousElementSibling && clientY < this.middleOf(row.previousElementSibling)) row.after(row.previousElementSibling)
  }

  drop() {
    if (this.rowTargets.indexOf(this.dragged) !== this.startingIndex) this.announce(this.dragged)
    this.dragged = null
  }

  middleOf(row) {
    const { top, height } = row.getBoundingClientRect()
    return top + height / 2
  }

  announce(row) {
    const rows = this.rowTargets
    this.statusTarget.textContent = `${row.dataset.label} is number ${rows.indexOf(row) + 1} of ${rows.length}.`
  }

  rowHolding(element) {
    return element.closest('[data-sortable-list-target="row"]')
  }
}
