import { test } from "node:test"
import assert from "node:assert/strict"

test("the chart controller loads without the charting script, so a page with no chart never downloads it", async () => {
  const module = await import("../../app/assets/javascripts/keystone_ui/line_chart_controller.js")

  assert.equal(typeof module.default, "function")
})

test("a day on a dated chart's axis reads as its date", async () => {
  const { dayLabel } = await import("../../app/assets/javascripts/keystone_ui/line_chart_controller.js")

  assert.equal(dayLabel(20614), "Jun 10, 2026")
})

test("a chart with labels keeps the charting script's own axis", async () => {
  const { chartOptions } = await import("../../app/assets/javascripts/keystone_ui/line_chart_controller.js")

  assert.equal(chartOptions(false).scales, undefined)
})

test("a dated chart spaces its points by the days between them", async () => {
  const { chartOptions } = await import("../../app/assets/javascripts/keystone_ui/line_chart_controller.js")

  assert.equal(chartOptions(true).scales.x.type, "linear")
})

test("a dated chart's axis reads each day as its date", async () => {
  const { chartOptions } = await import("../../app/assets/javascripts/keystone_ui/line_chart_controller.js")

  assert.equal(chartOptions(true).scales.x.ticks.callback(20614), "Jun 10, 2026")
})

test("a dated chart's axis marks whole days only", async () => {
  const { chartOptions } = await import("../../app/assets/javascripts/keystone_ui/line_chart_controller.js")

  assert.equal(chartOptions(true).scales.x.ticks.precision, 0)
})

test("hovering a point on a dated chart names its date", async () => {
  const { chartOptions } = await import("../../app/assets/javascripts/keystone_ui/line_chart_controller.js")

  assert.equal(chartOptions(true).plugins.tooltip.callbacks.title([{ parsed: { x: 20614 } }]), "Jun 10, 2026")
})

test("a dated chart's axis runs from its first day to its last", async () => {
  const { chartOptions } = await import("../../app/assets/javascripts/keystone_ui/line_chart_controller.js")

  assert.equal(chartOptions(true).scales.x.bounds, "data")
})
