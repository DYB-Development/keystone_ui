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

test("clicking a closed row marks its button as expanded", () => {
  const { controller, row, button, cell } = closedRow()

  controller.toggle({ currentTarget: row, target: cell })

  assert.equal(button.getAttribute("aria-expanded"), "true")
})

test("clicking an open row hides its detail again", () => {
  const { controller, row, cell, detail } = closedRow()

  controller.toggle({ currentTarget: row, target: cell })
  controller.toggle({ currentTarget: row, target: cell })

  assert.equal(detail.hidden, true)
})

test("clicking a link in a row leaves its detail closed", () => {
  const { controller, row, detail } = closedRow()
  const link = {}
  link.closest = () => link

  controller.toggle({ currentTarget: row, target: link })

  assert.equal(detail.hidden, true)
})
