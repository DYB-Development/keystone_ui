import { test } from "node:test"
import assert from "node:assert/strict"
import ColumnPickerController from "../../app/assets/javascripts/keystone_ui/column_picker_controller.js"

function pickerWith(columns) {
  const options = columns.map(({ key, shown }) => {
    const checkbox = { value: key, checked: shown }
    return { querySelector: () => checkbox }
  })
  const controller = new ColumnPickerController({ scope: { element: {} } })
  Object.defineProperty(controller, "optionTargets", { value: options })
  Object.defineProperty(controller, "hasSaveUrlValue", { value: true })
  Object.defineProperty(controller, "saveUrlValue", { value: "/preferences/months" })
  return { controller, options }
}

function sentBodies(run) {
  const bodies = []
  globalThis.document = { querySelector: () => null }
  globalThis.Turbo = { visit() {} }
  globalThis.window = { location: { href: "/months" } }
  globalThis.fetch = (url, request) => {
    bodies.push(JSON.parse(request.body))
    return Promise.resolve()
  }
  run()
  return bodies
}

test("moving a column up sends the new order and the hidden columns in one request", () => {
  const { controller, options } = pickerWith([
    { key: "pipeline", shown: true },
    { key: "outreach", shown: false }
  ])

  const bodies = sentBodies(() => controller.moveUp({ currentTarget: { closest: () => options[1] } }))

  assert.deepEqual(bodies, [ { hidden_columns: [ "outreach" ], column_order: [ "outreach", "pipeline" ] } ])
})

test("moving a column down sends the new order and the hidden columns in one request", () => {
  const { controller, options } = pickerWith([
    { key: "pipeline", shown: true },
    { key: "outreach", shown: false }
  ])

  const bodies = sentBodies(() => controller.moveDown({ currentTarget: { closest: () => options[0] } }))

  assert.deepEqual(bodies, [ { hidden_columns: [ "outreach" ], column_order: [ "outreach", "pipeline" ] } ])
})
