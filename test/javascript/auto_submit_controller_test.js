import { test, afterEach } from "node:test"
import assert from "node:assert/strict"
import AutoSubmitController from "../../app/assets/javascripts/keystone_ui/auto_submit_controller.js"

const connected = []

afterEach(() => {
  connected.splice(0).forEach((controller) => controller.disconnect())
})

function formWith() {
  const form = { submitted: 0, requestSubmit() { this.submitted += 1 }, contains(node) { return node?.inForm === true } }
  const controller = new AutoSubmitController({ scope: { element: form } })
  Object.defineProperty(controller, "delayValue", { value: 500 })
  connected.push(controller)
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

test("ticking a checkbox submits the form at once", () => {
  const { controller, form } = formWith()

  controller.changed({ target: field("checkbox") })

  assert.equal(form.submitted, 1)
})

test("choosing a radio button submits the form at once", () => {
  const { controller, form } = formWith()

  controller.changed({ target: field("radio") })

  assert.equal(form.submitted, 1)
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

test("a refresh that replaces the field the person is in puts their caret back where it was", () => {
  const { controller } = formWith()
  const { replacement, replace } = replacedWhileTyping()

  controller.remember()
  replace()
  controller.restore()

  assert.deepEqual(replacement.selection, [2, 2])
})

test("a refresh leaves alone the focus of a field outside the auto-submit form", () => {
  const { controller } = formWith()
  const { replacement, replace } = replacedWhileTyping({ inForm: false })

  controller.remember()
  replace()
  controller.restore()

  assert.equal(replacement.focused, false)
})

test("a refresh that kept the person's field in place leaves their caret alone", () => {
  const { controller } = formWith()
  const { replacement } = replacedWhileTyping()
  Object.assign(replacement, { inForm: true, selectionStart: 2, selectionEnd: 2 })
  globalThis.document.activeElement = replacement

  controller.remember()
  controller.restore()

  assert.equal(replacement.selection, undefined)
})

test("a change made while the form's last submission is still being sent waits for it to finish", () => {
  const { controller, form } = formWith()

  controller.started()
  controller.changed({ target: field("select-one", "SELECT") })

  assert.equal(form.submitted, 0)
})

function streamsOnPage(streams = []) {
  globalThis.document = { querySelectorAll: (selector) => (selector === "turbo-stream" ? streams : []) }
}

test("a change held while the last submission was sent is sent once that submission finishes", async () => {
  const { controller, form } = formWith()
  streamsOnPage()

  controller.started()
  controller.changed({ target: field("select-one", "SELECT") })
  await controller.finished({ detail: { success: true } })

  assert.equal(form.submitted, 1)
})

test("several changes held while the last submission was sent are sent together as one submission", async () => {
  const { controller, form } = formWith()
  streamsOnPage()

  controller.started()
  controller.changed({ target: field("select-one", "SELECT") })
  controller.changed({ target: field("checkbox") })
  controller.changed({ target: field("radio") })
  await controller.finished({ detail: { success: true } })

  assert.equal(form.submitted, 1)
})

function streamRendering() {
  let finishRendering
  const drawn = new Promise((resolve) => { finishRendering = resolve })
  return { stream: { render: () => drawn }, finishRendering }
}

test("a held change waits until the Turbo Stream answer to the last submission has been drawn", async () => {
  const { controller, form } = formWith()
  const { stream, finishRendering } = streamRendering()
  streamsOnPage([ stream ])

  controller.started()
  controller.changed({ target: field("select-one", "SELECT") })
  const finishing = controller.finished({ detail: { success: true, fetchResponse: { responseHTML: Promise.resolve("<turbo-stream></turbo-stream>") } } })
  await new Promise((resolve) => setTimeout(resolve, 10))
  const sentBeforeDrawn = form.submitted
  finishRendering()
  await finishing

  assert.deepEqual([sentBeforeDrawn, form.submitted], [0, 1])
})

test("a held change is still sent when the answer to the last submission cannot be read", async () => {
  const { controller, form } = formWith()
  streamsOnPage()

  controller.started()
  controller.changed({ target: field("select-one", "SELECT") })
  await controller.finished({ detail: { success: false, fetchResponse: { responseHTML: Promise.reject(new Error("connection lost")) } } }).catch(() => {})

  assert.equal(form.submitted, 1)
})

test("a held change is still sent when the last submission failed to reach the server", async () => {
  const { controller, form } = formWith()
  streamsOnPage()

  controller.started()
  controller.changed({ target: field("select-one", "SELECT") })
  await controller.finished({ detail: { success: false, error: new TypeError("Failed to fetch") } })

  assert.equal(form.submitted, 1)
})

test("a form taken off the page while sending, then put back, sends its next change at once", () => {
  const { controller, form } = formWith()

  controller.started()
  controller.disconnect()
  controller.changed({ target: field("select-one", "SELECT") })

  assert.equal(form.submitted, 1)
})

test("a change in one auto-submit form waits while another auto-submit form's submission is still being sent", () => {
  const first = formWith()
  const second = formWith()

  first.controller.started()
  second.controller.changed({ target: field("select-one", "SELECT") })

  assert.equal(second.form.submitted, 0)
})

test("a change held behind another auto-submit form's submission is sent once that submission finishes", async () => {
  const first = formWith()
  const second = formWith()
  streamsOnPage()

  first.controller.started()
  second.controller.changed({ target: field("select-one", "SELECT") })
  await first.controller.finished({ detail: { success: true } })

  assert.equal(second.form.submitted, 1)
})

test("forms held behind a submission are sent one at a time, the first held going first", async () => {
  const sent = formWith()
  const firstHeld = formWith()
  const secondHeld = formWith()
  streamsOnPage()

  sent.controller.started()
  firstHeld.controller.changed({ target: field("select-one", "SELECT") })
  secondHeld.controller.changed({ target: field("select-one", "SELECT") })
  firstHeld.controller.changed({ target: field("checkbox") })
  await sent.controller.finished({ detail: { success: true } })

  assert.deepEqual([firstHeld.form.submitted, secondHeld.form.submitted], [1, 0])
})

test("a held form taken off the page is not sent once the submission it waited behind finishes", async () => {
  const sent = formWith()
  const held = formWith()
  streamsOnPage()

  sent.controller.started()
  held.controller.changed({ target: field("select-one", "SELECT") })
  held.controller.disconnect()
  await sent.controller.finished({ detail: { success: true } })

  assert.equal(held.form.submitted, 0)
})

test("a form taken off the page while its submission is being sent lets the next held form be sent", () => {
  const sent = formWith()
  const held = formWith()

  sent.controller.started()
  held.controller.changed({ target: field("select-one", "SELECT") })
  sent.controller.disconnect()

  assert.equal(held.form.submitted, 1)
})

test("a form replaced by the Turbo Stream answer to its own submission holds the next form until that answer has been drawn", async () => {
  const sent = formWith()
  const held = formWith()
  const { stream, finishRendering } = streamRendering()
  streamsOnPage([ stream ])

  sent.controller.started()
  held.controller.changed({ target: field("select-one", "SELECT") })
  const finishing = sent.controller.finished({ detail: { success: true, fetchResponse: { responseHTML: Promise.resolve("<turbo-stream></turbo-stream>") } } })
  await new Promise((resolve) => setTimeout(resolve, 10))
  sent.controller.disconnect()
  const sentBeforeDrawn = held.form.submitted
  finishRendering()
  await finishing

  assert.deepEqual([sentBeforeDrawn, held.form.submitted], [0, 1])
})

test("a change made after an auto-submit form is sent and before Turbo starts its submission is held", () => {
  const first = formWith()
  const second = formWith()

  first.controller.changed({ target: field("select-one", "SELECT") })
  second.controller.changed({ target: field("select-one", "SELECT") })

  assert.equal(second.form.submitted, 0)
})

test("a send that Turbo does not start in the same task lets the next held form be sent", async () => {
  const first = formWith()
  const second = formWith()

  first.controller.changed({ target: field("select-one", "SELECT") })
  second.controller.changed({ target: field("select-one", "SELECT") })
  await new Promise((resolve) => setTimeout(resolve))

  assert.equal(second.form.submitted, 1)
})
