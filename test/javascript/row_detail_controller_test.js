import { test } from "node:test"
import assert from "node:assert/strict"
import RowDetailController from "../../app/assets/javascripts/keystone_ui/row_detail_controller.js"

function closedRow() {
  const attributes = { "aria-expanded": "false", "aria-controls": "row-detail-7" }
  const button = {
    getAttribute: (name) => attributes[name],
    setAttribute: (name, value) => { attributes[name] = value }
  }
  button.closest = () => button
  const detail = { hidden: true }
  const row = { querySelector: () => button }
  const cell = { closest: () => null }
  const element = { querySelector: (selector) => (selector === '[id="row-detail-7"]' ? detail : null) }
  const controller = new RowDetailController({ scope: { element } })
  return { controller, row, button, cell, detail }
}

test("clicking a closed row shows its detail", () => {
  const { controller, row, cell, detail } = closedRow()

  controller.toggle({ currentTarget: row, target: cell })

  assert.equal(detail.hidden, false)
})
