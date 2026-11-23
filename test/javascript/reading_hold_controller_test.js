import { test, mock } from "node:test"
import assert from "node:assert/strict"
import ReadingHoldController from "../../app/assets/javascripts/keystone_ui/reading_hold_controller.js"

function fakeElement() {
  const attributes = {}
  return {
    attributes,
    textContent: "",
    setAttribute(name, value) { attributes[name] = String(value) },
    removeAttribute(name) { delete attributes[name] },
    getAttribute(name) { return name in attributes ? attributes[name] : null }
  }
}

function holdWith({ seconds = 0, elapsed = 0, requireEnd = false } = {}) {
  const button = fakeElement()
  const controller = new ReadingHoldController({ scope: { element: {} } })
  Object.defineProperty(controller, "buttonTarget", { value: button })
  Object.defineProperty(controller, "secondsValue", { value: seconds })
  Object.defineProperty(controller, "elapsedValue", { value: elapsed })
  Object.defineProperty(controller, "requireEndValue", { value: requireEnd })
  return { controller, button }
}

test("a hold with seconds left keeps the button unavailable", (t) => {
  t.mock.timers.enable({ apis: ["setInterval"] })
  const { controller, button } = holdWith({ seconds: 30 })

  controller.connect()

  assert.equal(button.getAttribute("aria-disabled"), "true")
  controller.disconnect()
})

test("the button becomes available once the seconds have passed", (t) => {
  t.mock.timers.enable({ apis: ["setInterval"] })
  const { controller, button } = holdWith({ seconds: 30 })

  controller.connect()
  t.mock.timers.tick(30000)

  assert.equal(button.getAttribute("aria-disabled"), null)
  controller.disconnect()
})

test("seconds the page says were already spent count toward the hold", (t) => {
  t.mock.timers.enable({ apis: ["setInterval"] })
  const { controller, button } = holdWith({ seconds: 30, elapsed: 25 })

  controller.connect()
  t.mock.timers.tick(5000)

  assert.equal(button.getAttribute("aria-disabled"), null)
  controller.disconnect()
})
