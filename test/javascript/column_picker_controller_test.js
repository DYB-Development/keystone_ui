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
  const error = { classList: classes("hidden") }
  const controller = new ColumnPickerController({ scope: { element: { contains: (target) => target === inside } } })
  Object.defineProperty(controller, "optionTargets", { get: () => options.slice() })
  Object.defineProperty(controller, "menuTarget", { value: menu })
  Object.defineProperty(controller, "errorTarget", { value: error })
  Object.defineProperty(controller, "hasSaveUrlValue", { value: true })
  Object.defineProperty(controller, "saveUrlValue", { value: "/preferences/months" })
  const on = (index) => ({ currentTarget: { closest: () => options[index] } })
  return { controller, options, menu, error, on, outside: { target: {} } }
}

function sentBodies(run) {
  const bodies = []
  globalThis.document = { querySelector: () => null }
  globalThis.Turbo = { visit() {} }
  globalThis.window = { location: { href: "/months" } }
  globalThis.fetch = (url, request) => {
    bodies.push(JSON.parse(request.body))
    return Promise.resolve({ ok: true })
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

test("after a move only the new first column's up button and the new last column's down button are disabled", () => {
  const { controller, options, on } = pickerWith([
    { key: "pipeline", shown: true },
    { key: "outreach", shown: true }
  ])
  options[0].parts.up.disabled = true
  options[1].parts.down.disabled = true

  sentBodies(() => controller.moveUp(on(1)))

  assert.deepEqual(options.map(({ parts }) => [ parts.checkbox.value, parts.up.disabled, parts.down.disabled ]), [ [ "outreach", true, false ], [ "pipeline", false, true ] ])
})

test("closing the menu with its Columns button after a tick sends the hidden columns and the order once", () => {
  const { controller, options, on } = pickerWith([
    { key: "outreach", shown: true },
    { key: "pipeline", shown: true }
  ])
  options[1].parts.checkbox.checked = false

  const bodies = sentBodies(() => {
    controller.mark(on(1))
    controller.toggle({ stopPropagation() {} })
  })

  assert.deepEqual(bodies, [ { hidden_columns: [ "pipeline" ], column_order: [ "outreach", "pipeline" ] } ])
})

async function afterSaving(answer, run) {
  const visits = []
  globalThis.document = { querySelector: () => null, addEventListener() {}, removeEventListener() {} }
  globalThis.Turbo = { visit: (url) => visits.push(url) }
  globalThis.window = { location: { href: "/months" } }
  globalThis.fetch = () => answer()
  run()
  await new Promise((resolve) => setImmediate(resolve))
  return visits
}

test("a save the server answers with an error shows that the change was not saved", async () => {
  const { controller, options, error, on, outside } = pickerWith([
    { key: "outreach", shown: true },
    { key: "pipeline", shown: true }
  ])
  options[1].parts.checkbox.checked = false

  await afterSaving(() => Promise.resolve({ ok: false }), () => {
    controller.connect()
    controller.mark(on(1))
    controller.close(outside)
  })

  assert.equal(error.classList.contains("hidden"), false)
})

test("a save that cannot reach the server shows that the change was not saved", async () => {
  const { controller, options, error, on, outside } = pickerWith([
    { key: "outreach", shown: true },
    { key: "pipeline", shown: true }
  ])
  options[1].parts.checkbox.checked = false

  await afterSaving(() => Promise.reject(new TypeError("Failed to fetch")), () => {
    controller.connect()
    controller.mark(on(1))
    controller.close(outside)
  })

  assert.equal(error.classList.contains("hidden"), false)
})

test("a failed save leaves the page without reloading it", async () => {
  const { controller, options, on, outside } = pickerWith([
    { key: "outreach", shown: true },
    { key: "pipeline", shown: true }
  ])
  options[1].parts.checkbox.checked = false

  const visits = await afterSaving(() => Promise.resolve({ ok: false }), () => {
    controller.connect()
    controller.mark(on(1))
    controller.close(outside)
  })

  assert.deepEqual(visits, [])
})

test("after a failed save the menu's boxes go back to what the table shows", async () => {
  const { controller, options, on, outside } = pickerWith([
    { key: "outreach", shown: true },
    { key: "pipeline", shown: true }
  ])

  await afterSaving(() => Promise.resolve({ ok: false }), () => {
    controller.connect()
    options[1].parts.checkbox.checked = false
    controller.mark(on(1))
    controller.close(outside)
  })

  assert.deepEqual(options.map(({ parts }) => [ parts.checkbox.checked, parts.label.classList.contains("ks-menu-option-hidden") ]), [ [ true, false ], [ true, false ] ])
})

test("after a failed save the menu's order goes back to what the table shows", async () => {
  const { controller, options, on, outside } = pickerWith([
    { key: "outreach", shown: true },
    { key: "pipeline", shown: true }
  ])

  await afterSaving(() => Promise.resolve({ ok: false }), () => {
    controller.connect()
    controller.moveUp(on(1))
    controller.close(outside)
  })

  assert.deepEqual(options.map(({ parts }) => parts.checkbox.value), [ "outreach", "pipeline" ])
})
