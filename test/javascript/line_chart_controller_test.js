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

  assert.equal(chartOptions(false).scales.x.type, undefined)
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

const readVariableName = (name) => `color of ${name}`

test("series with no colour of their own take the theme's five chart colours in order", async () => {
  const { themeColors, styleDatasets } = await import("../../app/assets/javascripts/keystone_ui/line_chart_controller.js")

  const datasets = styleDatasets([{}, {}, {}, {}, {}, {}], themeColors(readVariableName, false), (color) => color)

  assert.deepEqual(datasets.map((dataset) => dataset.borderColor), [
    "color of --ks-color-chart-1",
    "color of --ks-color-chart-2",
    "color of --ks-color-chart-3",
    "color of --ks-color-chart-4",
    "color of --ks-color-chart-5",
    "color of --ks-color-chart-1"
  ])
})

test("a series keeps the colour its caller gives it", async () => {
  const { themeColors, styleDatasets } = await import("../../app/assets/javascripts/keystone_ui/line_chart_controller.js")

  const [dataset] = styleDatasets([{ borderColor: "#94a3b8" }], themeColors(readVariableName, false), (color) => color)

  assert.equal(dataset.borderColor, "#94a3b8")
})

test("lines are thin and show no dot on each data point", async () => {
  const { chartOptions } = await import("../../app/assets/javascripts/keystone_ui/line_chart_controller.js")

  const { elements } = chartOptions(false)

  assert.deepEqual([elements.line.borderWidth, elements.point.radius], [1.5, 0])
})

test("a dot appears on a data point while the cursor is over it", async () => {
  const { chartOptions } = await import("../../app/assets/javascripts/keystone_ui/line_chart_controller.js")

  assert.equal(chartOptions(false).elements.point.hoverRadius, 4)
})

test("the dot on a data point under the cursor is filled in its line's colour", async () => {
  const { themeColors, styleDatasets } = await import("../../app/assets/javascripts/keystone_ui/line_chart_controller.js")

  const [dataset] = styleDatasets([{ borderColor: "#94a3b8" }], themeColors(readVariableName, false), (color) => color)

  assert.equal(dataset.pointHoverBackgroundColor, "#94a3b8")
})

test("the chart draws only horizontal grid lines, in the theme's border colour", async () => {
  const { chartOptions, themeColors } = await import("../../app/assets/javascripts/keystone_ui/line_chart_controller.js")

  const { scales } = chartOptions(false, themeColors(readVariableName, false))

  assert.deepEqual([scales.x.grid.display, scales.y.grid.color], [false, "color of --ks-color-border"])
})

test("axis text is small, in the theme's muted text colour and the app's body font", async () => {
  const { chartOptions, themeColors } = await import("../../app/assets/javascripts/keystone_ui/line_chart_controller.js")

  const { scales } = chartOptions(true, themeColors(readVariableName, false))
  const axisText = { color: "color of --ks-color-text-muted", font: { size: 11, family: "color of --ks-font-body" } }

  assert.deepEqual([scales.x.ticks, scales.y.ticks].map(({ color, font }) => ({ color, font })), [axisText, axisText])
})

test("axis text uses the font the chart inherits when the theme's body font is left to inherit", async () => {
  const { themeColors } = await import("../../app/assets/javascripts/keystone_ui/line_chart_controller.js")

  const theme = themeColors((name) => (name === "--ks-font-body" ? "inherit" : ""), false, "Inter, sans-serif")

  assert.equal(theme.font, "Inter, sans-serif")
})

test("the tooltip uses the theme's surface, border and text colours", async () => {
  const { chartOptions, themeColors } = await import("../../app/assets/javascripts/keystone_ui/line_chart_controller.js")

  const { backgroundColor, borderColor, titleColor, bodyColor } = chartOptions(true, themeColors(readVariableName, false)).plugins.tooltip

  assert.deepEqual([backgroundColor, borderColor, titleColor, bodyColor], [
    "color of --ks-color-surface",
    "color of --ks-color-border",
    "color of --ks-color-text",
    "color of --ks-color-text"
  ])
})

test("when the chart first appears, each line draws in from left to right", async () => {
  const { chartOptions } = await import("../../app/assets/javascripts/keystone_ui/line_chart_controller.js")

  const { animations } = chartOptions(false, {}, true)
  const chart = { data: { datasets: [{ data: [1, 2, 3, 4, 5, 6] }] } }
  const delays = [0, 1, 2, 3, 4, 5].map((index) => animations.x.delay({ type: "data", mode: "default", index, datasetIndex: 0, chart }))

  assert.deepEqual(delays, [0, 100, 200, 300, 400, 500])
})

test("a chart for someone who prefers reduced motion appears without animating", async () => {
  const { chartOptions } = await import("../../app/assets/javascripts/keystone_ui/line_chart_controller.js")

  assert.equal(chartOptions(false, {}, false).animation, false)
})

test("resizing a chart moves its lines without drawing them in again", async () => {
  const { chartOptions } = await import("../../app/assets/javascripts/keystone_ui/line_chart_controller.js")

  const { animations } = chartOptions(false, {}, true)
  const chart = { data: { datasets: [{ data: [1, 2, 3, 4, 5, 6] }] } }

  assert.equal(animations.x.duration({ type: "data", mode: "resize", index: 3, datasetIndex: 0, chart }), 0)
})
