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

test("Move down puts the row below the one after it", () => {
  const { controller, button, order } = list()

  controller.moveDown({ currentTarget: button("Bo") })

  assert.deepEqual(order(), ["Ann", "Cy", "Bo"])
})

test("Move up announces the row's new position", () => {
  const { controller, button, status } = list()

  controller.moveUp({ currentTarget: button("Bo") })

  assert.equal(status.textContent, "Bo is number 1 of 3.")
})

test("Move down announces the row's new position", () => {
  const { controller, button, status } = list()

  controller.moveDown({ currentTarget: button("Bo") })

  assert.equal(status.textContent, "Bo is number 3 of 3.")
})

function pointer(handle, overrides = {}) {
  return { currentTarget: handle, pointerId: 1, button: 0, clientY: 0, ...overrides }
}

function handle(rows, label) {
  const captured = []
  return {
    captured,
    setPointerCapture: (id) => captured.push(id),
    closest: () => rows.find((row) => row.dataset.label === label)
  }
}

test("grabbing a handle captures the pointer, so the row follows it off the handle", () => {
  const { controller, rows } = list()
  const bo = handle(rows, "Bo")

  controller.grab(pointer(bo))

  assert.deepEqual(bo.captured, [1])
})

test("dragging below the middle of the next row moves the row down", () => {
  const { controller, rows, order } = list()
  const bo = handle(rows, "Bo")
  controller.grab(pointer(bo, { clientY: 60 }))

  controller.drag(pointer(bo, { clientY: 101 }))

  assert.deepEqual(order(), ["Ann", "Cy", "Bo"])
})

test("dragging above the middle of the previous row moves the row up", () => {
  const { controller, rows, order } = list()
  const cy = handle(rows, "Cy")
  controller.grab(pointer(cy, { clientY: 100 }))

  controller.drag(pointer(cy, { clientY: 19 }))

  assert.deepEqual(order(), ["Cy", "Ann", "Bo"])
})

test("a pointer passing over a handle without grabbing it moves nothing", () => {
  const { controller, rows, order } = list()

  controller.drag(pointer(handle(rows, "Bo"), { clientY: 101 }))

  assert.deepEqual(order(), ["Ann", "Bo", "Cy"])
})

test("releasing the handle ends the drag", () => {
  const { controller, rows, order } = list()
  const bo = handle(rows, "Bo")
  controller.grab(pointer(bo, { clientY: 60 }))

  controller.drop(pointer(bo, { clientY: 60 }))
  controller.drag(pointer(bo, { clientY: 101 }))

  assert.deepEqual(order(), ["Ann", "Bo", "Cy"])
})

test("dropping a row in a new place announces its position", () => {
  const { controller, rows, status } = list()
  const bo = handle(rows, "Bo")
  controller.grab(pointer(bo, { clientY: 60 }))
  controller.drag(pointer(bo, { clientY: 101 }))

  controller.drop(pointer(bo, { clientY: 101 }))

  assert.equal(status.textContent, "Bo is number 3 of 3.")
})

test("dropping a row where it started announces nothing", () => {
  const { controller, rows, status } = list()
  const bo = handle(rows, "Bo")
  controller.grab(pointer(bo, { clientY: 60 }))

  controller.drop(pointer(bo, { clientY: 60 }))

  assert.equal(status.textContent, "")
})

test("a grabbed row is marked as dragging until it is dropped", () => {
  const { controller, rows } = list()
  const bo = handle(rows, "Bo")
  const row = rows[1]

  controller.grab(pointer(bo))
  const whileGrabbed = row.dataset.dragging
  controller.drop(pointer(bo))

  assert.deepEqual([whileGrabbed, row.dataset.dragging], ["true", undefined])
})

test("releasing a pointer that grabbed nothing does nothing", () => {
  const { controller, rows } = list()

  assert.doesNotThrow(() => controller.drop(pointer(handle(rows, "Bo"))))
})
