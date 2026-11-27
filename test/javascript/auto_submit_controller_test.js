import { test } from "node:test"
import assert from "node:assert/strict"
import AutoSubmitController from "../../app/assets/javascripts/keystone_ui/auto_submit_controller.js"

function formWith() {
  const form = { submitted: 0, requestSubmit() { this.submitted += 1 }, contains(node) { return node?.inForm === true } }
  const controller = new AutoSubmitController({ scope: { element: form } })
  Object.defineProperty(controller, "delayValue", { value: 500 })
  return { controller, form }
}

test("submitting sends the form through Turbo's own submit", () => {
  const { controller, form } = formWith()

  controller.submit()

  assert.equal(form.submitted, 1)
})

function field(type, tagName = "INPUT") {
  return { type, tagName }
}

test("choosing an option in a select submits the form at once", () => {
  const { controller, form } = formWith()

  controller.changed({ target: field("select-one", "SELECT") })

  assert.equal(form.submitted, 1)
})

test("ticking a checkbox or choosing a radio button submits the form at once", () => {
  const { controller, form } = formWith()

  controller.changed({ target: field("checkbox") })
  controller.changed({ target: field("radio") })

  assert.equal(form.submitted, 2)
})

test("leaving a text field with nothing new typed sends nothing", () => {
  const { controller, form } = formWith()

  controller.changed({ target: field("text") })

  assert.equal(form.submitted, 0)
})

test("typing in a number field submits the form once the typing pauses", (t) => {
  t.mock.timers.enable({ apis: ["setTimeout"] })
  const { controller, form } = formWith()

  controller.typed({ target: field("number") })
  t.mock.timers.tick(500)

  assert.equal(form.submitted, 1)
})

test("each keystroke waits again before the form is submitted", (t) => {
  t.mock.timers.enable({ apis: ["setTimeout"] })
  const { controller, form } = formWith()

  controller.typed({ target: field("text") })
  t.mock.timers.tick(400)
  controller.typed({ target: field("text") })
  t.mock.timers.tick(400)

  assert.equal(form.submitted, 0)
})

test("an input event from a select or checkbox leaves submitting to its change, so it is sent once", (t) => {
  t.mock.timers.enable({ apis: ["setTimeout"] })
  const { controller, form } = formWith()

  controller.typed({ target: field("select-one", "SELECT") })
  controller.typed({ target: field("checkbox") })
  t.mock.timers.tick(500)

  assert.equal(form.submitted, 0)
})

test("leaving a text field while its typing waits sends it at once and only once", (t) => {
  t.mock.timers.enable({ apis: ["setTimeout"] })
  const { controller, form } = formWith()

  controller.typed({ target: field("text") })
  controller.changed({ target: field("text") })
  const sentOnLeaving = form.submitted
  t.mock.timers.tick(500)

  assert.deepEqual([sentOnLeaving, form.submitted], [1, 1])
})

test("a form taken off the page does not send typing that was still waiting", (t) => {
  t.mock.timers.enable({ apis: ["setTimeout"] })
  const { controller, form } = formWith()

  controller.typed({ target: field("text") })
  controller.disconnect()
  t.mock.timers.tick(500)

  assert.equal(form.submitted, 0)
})

function morphOf(target, attributeName = "value") {
  const event = { target, detail: { attributeName, mutationType: "update" }, cancelled: false, preventDefault: () => { event.cancelled = true } }
  return event
}

test("a refresh keeps what the person is typing in the field they are in", () => {
  const { controller } = formWith()
  const typing = field("number")
  globalThis.document = { activeElement: typing }
  const event = morphOf(typing)

  controller.keep(event)

  assert.equal(event.cancelled, true)
})

test("a refresh still updates a field the person is not in", () => {
  const { controller } = formWith()
  globalThis.document = { activeElement: field("number") }
  const event = morphOf(field("text"))

  controller.keep(event)

  assert.equal(event.cancelled, false)
})

test("a refresh still updates attributes other than the value of the field the person is in", () => {
  const { controller } = formWith()
  const typing = field("number")
  globalThis.document = { activeElement: typing }
  const event = morphOf(typing, "class")

  controller.keep(event)

  assert.equal(event.cancelled, false)
})

function replacedWhileTyping({ inForm = true } = {}) {
  const typing = { id: "price-market", type: "text", inForm, selectionStart: 2, selectionEnd: 2 }
  const replacement = {
    id: "price-market",
    focused: false,
    focus() { this.focused = true },
    setSelectionRange(start, end) { this.selection = [start, end] }
  }
  globalThis.document = { activeElement: typing, body: {}, getElementById: (id) => (id === "price-market" ? replacement : null) }
  return { replacement, replace: () => { globalThis.document.activeElement = globalThis.document.body } }
}

test("a refresh that replaces the field the person is in puts their focus back on it", () => {
  const { controller } = formWith()
  const { replacement, replace } = replacedWhileTyping()

  controller.remember()
  replace()
  controller.restore()

  assert.equal(replacement.focused, true)
})
