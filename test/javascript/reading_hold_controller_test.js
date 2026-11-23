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
  const form = { appended: [], append(...fields) { this.appended.push(...fields) } }
  const button = Object.assign(fakeElement(), { form })
  const reached = { value: "" }
  const inViewOnLoad = { value: "" }
  const status = fakeElement()
  const announcer = fakeElement()
  observers = []
  const controller = new ReadingHoldController({ scope: { element: {} } })
  Object.defineProperty(controller, "buttonTarget", { value: button })
  Object.defineProperty(controller, "statusTarget", { value: status })
  Object.defineProperty(controller, "endTarget", { value: fakeElement() })
  Object.defineProperty(controller, "reachedTarget", { value: reached })
  Object.defineProperty(controller, "inViewOnLoadTarget", { value: inViewOnLoad })
  Object.defineProperty(controller, "announcerTarget", { value: announcer })
  Object.defineProperty(controller, "waitingValue", { value: "Available in {seconds} seconds" })
  Object.defineProperty(controller, "endWaitingValue", { value: "Read to the end to continue" })
  Object.defineProperty(controller, "readyValue", { value: "The button is now available" })
  Object.defineProperty(controller, "secondsValue", { value: seconds })
  Object.defineProperty(controller, "elapsedValue", { value: elapsed })
  Object.defineProperty(controller, "requireEndValue", { value: requireEnd })
  return { controller, button, status, announcer, form, reached, inViewOnLoad }
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

test("content whose end is in view when the page loads counts as reached at once", (t) => {
  t.mock.timers.enable({ apis: ["setInterval"] })
  const { controller, button } = holdWith({ requireEnd: true })

  controller.connect()
  showEnd(true)

  assert.equal(button.getAttribute("aria-disabled"), null)
  controller.disconnect()
})

test("the fields reporting the end are sent with the form holding the button", (t) => {
  t.mock.timers.enable({ apis: ["setInterval"] })
  const { controller, form, reached, inViewOnLoad } = holdWith({ requireEnd: true })

  controller.connect()

  assert.deepEqual(form.appended, [reached, inViewOnLoad])
  controller.disconnect()
})

test("the end report says the end was reached after scrolling and was not in view on load", (t) => {
  t.mock.timers.enable({ apis: ["setInterval"] })
  const { controller, reached, inViewOnLoad } = holdWith({ requireEnd: true })

  controller.connect()
  showEnd(false)
  showEnd(true)

  assert.deepEqual([reached.value, inViewOnLoad.value], ["true", "false"])
  controller.disconnect()
})

test("the end report says the end was in view on load", (t) => {
  t.mock.timers.enable({ apis: ["setInterval"] })
  const { controller, reached, inViewOnLoad } = holdWith({ requireEnd: true })

  controller.connect()
  showEnd(true)

  assert.deepEqual([reached.value, inViewOnLoad.value], ["true", "true"])
  controller.disconnect()
})

test("a screen reader is told once that the button is now available", (t) => {
  t.mock.timers.enable({ apis: ["setInterval"] })
  const { controller, announcer } = holdWith({ seconds: 2 })

  controller.connect()
  t.mock.timers.tick(2000)

  assert.equal(announcer.textContent, "The button is now available")
  controller.disconnect()
})

test("a screen reader is not told about each passing second", (t) => {
  t.mock.timers.enable({ apis: ["setInterval"] })
  const { controller, announcer } = holdWith({ seconds: 30 })

  controller.connect()
  t.mock.timers.tick(3000)

  assert.equal(announcer.textContent, "")
  controller.disconnect()
})

test("a hold waiting only on the end says the end has to be reached", (t) => {
  t.mock.timers.enable({ apis: ["setInterval"] })
  const { controller, status } = holdWith({ requireEnd: true })

  controller.connect()

  assert.equal(status.textContent, "Read to the end to continue")
  controller.disconnect()
})

test("pressing the button while it is unavailable does nothing", (t) => {
  t.mock.timers.enable({ apis: ["setInterval"] })
  const { controller } = holdWith({ seconds: 30 })
  let prevented = false

  controller.connect()
  controller.guard({ preventDefault: () => { prevented = true } })

  assert.equal(prevented, true)
  controller.disconnect()
})

test("pressing the button once it is available goes ahead", (t) => {
  t.mock.timers.enable({ apis: ["setInterval"] })
  const { controller } = holdWith({ seconds: 1 })
  let prevented = false

  controller.connect()
  t.mock.timers.tick(1000)
  controller.guard({ preventDefault: () => { prevented = true } })

  assert.equal(prevented, false)
  controller.disconnect()
})

test("the page Turbo keeps for going back shows the button held again", (t) => {
  t.mock.timers.enable({ apis: ["setInterval"] })
  const { controller, button } = holdWith({ seconds: 1 })

  controller.connect()
  t.mock.timers.tick(1000)
  controller.holdForCache()

  assert.equal(button.getAttribute("aria-disabled"), "true")
  controller.disconnect()
})
