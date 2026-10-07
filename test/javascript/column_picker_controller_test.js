import { test } from "node:test"
import assert from "node:assert/strict"
import ColumnPickerController from "../../app/assets/javascripts/keystone_ui/column_picker_controller.js"

function classes(...names) {
  const set = new Set(names)
  return {
    add: (name) => set.add(name),
    remove: (name) => set.delete(name),
    toggle: (name, force) => ((force ?? !set.has(name)) ? set.add(name) : set.delete(name)),
    contains: (name) => set.has(name)
  }
}

function pickerWith(columns) {
  const options = []
  const list = {
    insertBefore(node, reference) {
      options.splice(options.indexOf(node), 1)
      options.splice(reference ? options.indexOf(reference) : options.length, 0, node)
    }
  }
  columns.forEach(({ key, shown }) => {
    const parts = {
      checkbox: { value: key, checked: shown },
      label: { classList: classes() },
      up: { disabled: false },
      down: { disabled: false }
    }
    const option = {
      parts,
      parentNode: list,
      get previousElementSibling() { return options[options.indexOf(option) - 1] || null },
      get nextElementSibling() { return options[options.indexOf(option) + 1] || null },
      querySelector(selector) {
        if (selector.includes("checkbox")) return parts.checkbox
        if (selector.includes("moveUp")) return parts.up
        if (selector.includes("moveDown")) return parts.down
        return parts.label
      }
    }
    options.push(option)
  })
  const inside = {}
  const menu = { classList: classes() }
  const controller = new ColumnPickerController({ scope: { element: { contains: (target) => target === inside } } })
  Object.defineProperty(controller, "optionTargets", { get: () => options.slice() })
  Object.defineProperty(controller, "menuTarget", { value: menu })
  Object.defineProperty(controller, "hasSaveUrlValue", { value: true })
  Object.defineProperty(controller, "saveUrlValue", { value: "/preferences/months" })
  const on = (index) => ({ currentTarget: { closest: () => options[index] } })
  return { controller, options, menu, on, outside: { target: {} } }
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

test("moving a column up and clicking outside the menu sends the new order and the hidden columns once", () => {
  const { controller, on, outside } = pickerWith([
    { key: "pipeline", shown: true },
    { key: "outreach", shown: false }
  ])

  const bodies = sentBodies(() => {
    controller.moveUp(on(1))
    controller.close(outside)
  })

  assert.deepEqual(bodies, [ { hidden_columns: [ "outreach" ], column_order: [ "outreach", "pipeline" ] } ])
})

test("moving a column down and clicking outside the menu sends the new order and the hidden columns once", () => {
  const { controller, on, outside } = pickerWith([
    { key: "pipeline", shown: true },
    { key: "outreach", shown: false }
  ])

  const bodies = sentBodies(() => {
    controller.moveDown(on(0))
    controller.close(outside)
  })

  assert.deepEqual(bodies, [ { hidden_columns: [ "outreach" ], column_order: [ "outreach", "pipeline" ] } ])
})

test("clicking outside the menu after a tick sends the hidden columns and the order once", () => {
  const { controller, options, on, outside } = pickerWith([
    { key: "outreach", shown: true },
    { key: "pipeline", shown: true }
  ])
  options[1].parts.checkbox.checked = false

  const bodies = sentBodies(() => {
    controller.mark(on(1))
    controller.close(outside)
  })

  assert.deepEqual(bodies, [ { hidden_columns: [ "pipeline" ], column_order: [ "outreach", "pipeline" ] } ])
})

test("ticking or unticking a column sends nothing while the menu is open", () => {
  const { controller, options, on } = pickerWith([
    { key: "outreach", shown: true },
    { key: "pipeline", shown: true }
  ])
  options[1].parts.checkbox.checked = false

  const bodies = sentBodies(() => controller.mark(on(1)))

  assert.deepEqual(bodies, [])
})

test("clicking outside the menu with nothing changed sends nothing", () => {
  const { controller, outside } = pickerWith([
    { key: "outreach", shown: true },
    { key: "pipeline", shown: false }
  ])

  const bodies = sentBodies(() => controller.close(outside))

  assert.deepEqual(bodies, [])
})

test("unticking a column greys its name straight away", () => {
  const { controller, options, on } = pickerWith([
    { key: "outreach", shown: true },
    { key: "pipeline", shown: true }
  ])
  options[1].parts.checkbox.checked = false

  sentBodies(() => controller.mark(on(1)))

  assert.equal(options[1].parts.label.classList.contains("ks-menu-option-hidden"), true)
})

test("ticking a hidden column again takes the grey off its name", () => {
  const { controller, options, on } = pickerWith([
    { key: "outreach", shown: true },
    { key: "pipeline", shown: false }
  ])
  options[1].parts.label.classList.add("ks-menu-option-hidden")
  options[1].parts.checkbox.checked = true

  sentBodies(() => controller.mark(on(1)))

  assert.equal(options[1].parts.label.classList.contains("ks-menu-option-hidden"), false)
})

test("moving a column up sends nothing while the menu is open", () => {
  const { controller, on } = pickerWith([
    { key: "pipeline", shown: true },
    { key: "outreach", shown: false }
  ])

  const bodies = sentBodies(() => controller.moveUp(on(1)))

  assert.deepEqual(bodies, [])
})

test("moving a column down sends nothing while the menu is open", () => {
  const { controller, on } = pickerWith([
    { key: "pipeline", shown: true },
    { key: "outreach", shown: false }
  ])

  const bodies = sentBodies(() => controller.moveDown(on(0)))

  assert.deepEqual(bodies, [])
})
