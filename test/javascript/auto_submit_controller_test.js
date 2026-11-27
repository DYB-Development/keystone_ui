import { test } from "node:test"
import assert from "node:assert/strict"
import AutoSubmitController from "../../app/assets/javascripts/keystone_ui/auto_submit_controller.js"

function formWith() {
  const form = { submitted: 0, requestSubmit() { this.submitted += 1 } }
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
