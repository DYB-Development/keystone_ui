import { test } from "node:test"
import assert from "node:assert/strict"

test("the chart controller loads without the charting script, so a page with no chart never downloads it", async () => {
  const module = await import("../../app/assets/javascripts/keystone_ui/line_chart_controller.js")

  assert.equal(typeof module.default, "function")
})
