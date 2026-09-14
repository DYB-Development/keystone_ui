import { test } from "node:test"
import assert from "node:assert/strict"
import DismissController from "../../app/assets/javascripts/keystone_ui/dismiss_controller.js"

test("closing removes the dismissable element from the page", () => {
  let removed = false
  const element = { remove: () => { removed = true } }

  new DismissController({ scope: { element } }).close()

  assert.equal(removed, true)
})
