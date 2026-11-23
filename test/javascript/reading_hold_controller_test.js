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

let observers = []

globalThis.IntersectionObserver = class {
  constructor(callback) {
    this.callback = callback
    observers.push(this)
  }

  observe() {}
  disconnect() {}
}

function showEnd(isIntersecting = true) {
  observers.at(-1).callback([{ isIntersecting }])
}

function holdWith({ seconds = 0, elapsed = 0, requireEnd = false } = {}) {
  const button = fakeElement()
  const status = fakeElement()
  observers = []
  const controller = new ReadingHoldController({ scope: { element: {} } })
  Object.defineProperty(controller, "buttonTarget", { value: button })
  Object.defineProperty(controller, "statusTarget", { value: status })
  Object.defineProperty(controller, "endTarget", { value: fakeElement() })
  Object.defineProperty(controller, "waitingValue", { value: "Available in {seconds} seconds" })
  Object.defineProperty(controller, "secondsValue", { value: seconds })
  Object.defineProperty(controller, "elapsedValue", { value: elapsed })
  Object.defineProperty(controller, "requireEndValue", { value: requireEnd })
  return { controller, button, status }
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

test("the seconds left are shown while the button is unavailable", (t) => {
  t.mock.timers.enable({ apis: ["setInterval"] })
  const { controller, status } = holdWith({ seconds: 30 })

  controller.connect()
  t.mock.timers.tick(1000)

  assert.equal(status.textContent, "Available in 29 seconds")
  controller.disconnect()
})

test("a hold that requires the end keeps the button unavailable until the end is in view", (t) => {
  t.mock.timers.enable({ apis: ["setInterval"] })
  const { controller, button } = holdWith({ requireEnd: true })

  controller.connect()

  assert.equal(button.getAttribute("aria-disabled"), "true")
  controller.disconnect()
})

test("the button becomes available once the end of the content comes into view", (t) => {
  t.mock.timers.enable({ apis: ["setInterval"] })
  const { controller, button } = holdWith({ requireEnd: true })

  controller.connect()
  showEnd(false)
  showEnd(true)

  assert.equal(button.getAttribute("aria-disabled"), null)
  controller.disconnect()
})

test("a hold that requires both the end and a time stays unavailable until the time has passed", (t) => {
  t.mock.timers.enable({ apis: ["setInterval"] })
  const { controller, button } = holdWith({ seconds: 30, requireEnd: true })

  controller.connect()
  showEnd(true)

  assert.equal(button.getAttribute("aria-disabled"), "true")
  controller.disconnect()
})
