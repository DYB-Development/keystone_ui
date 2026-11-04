import { test } from "node:test"
import assert from "node:assert/strict"
import SortableListController from "../../app/assets/javascripts/keystone_ui/sortable_list_controller.js"

const ROW_HEIGHT = 40

function list(labels = ["Ann", "Bo", "Cy"]) {
  const rows = []
  const makeRow = (label) => {
    const row = {
      dataset: { label },
      get previousElementSibling() { return rows[rows.indexOf(row) - 1] ?? null },
      get nextElementSibling() { return rows[rows.indexOf(row) + 1] ?? null },
      before(other) { place(other, rows.indexOf(row)) },
      after(other) { place(other, rows.indexOf(row) + 1) },
      getBoundingClientRect() {
        const top = rows.indexOf(row) * ROW_HEIGHT
        return { top, height: ROW_HEIGHT }
      }
    }
    return row
  }
  const place = (row, index) => {
    const from = rows.indexOf(row)
    rows.splice(index, 0, row)
    rows.splice(from < index ? from : from + 1, 1)
  }
  labels.forEach((label) => rows.push(makeRow(label)))

  const controller = new SortableListController({ scope: { element: {} } })
  const controls = [{ hidden: true }, { hidden: true }]
  const status = { textContent: "" }
  Object.defineProperty(controller, "rowTargets", { get: () => [...rows] })
  Object.defineProperty(controller, "controlTargets", { value: controls })
  Object.defineProperty(controller, "statusTarget", { value: status })

  const button = (label) => ({
    closest: () => rows.find((row) => row.dataset.label === label)
  })
  const order = () => rows.map((row) => row.dataset.label)
  return { controller, controls, status, button, order, rows }
}

test("connecting shows the handle and buttons that stay hidden without JavaScript", () => {
  const { controller, controls } = list()

  controller.connect()

  assert.deepEqual(controls.map((control) => control.hidden), [false, false])
})

test("Move up puts the row above the one before it", () => {
  const { controller, button, order } = list()

  controller.moveUp({ currentTarget: button("Bo") })

  assert.deepEqual(order(), ["Bo", "Ann", "Cy"])
})
