import { test } from "node:test"
import assert from "node:assert/strict"
import ColorPickerController from "../../app/assets/javascripts/keystone_ui/color_picker_controller.js"

function pickerWith(value) {
  const changes = []
  const parts = {
    swatch: { style: { backgroundColor: value } },
    text: { value },
    input: { value, dispatchEvent: (event) => changes.push(event.type) },
    hueSlider: { value: "0" },
    svGradient: { style: {} },
    svCursor: { style: {} }
  }
  const controller = new ColorPickerController({ scope: { element: {} } })
  Object.entries(parts).forEach(([ name, target ]) => {
    Object.defineProperty(controller, `${name}Target`, { value: target })
    Object.defineProperty(controller, `has${name[0].toUpperCase()}${name.slice(1)}Target`, { value: true })
  })
  Object.defineProperty(controller, "valueValue", { value })
  controller.connect()
  return { controller, changes, ...parts }
}

test("choosing a hue in the panel shows its six-digit hex in the text field", () => {
  const { controller, hueSlider, text } = pickerWith("#000000")
  controller.val = 1
  controller.sat = 1
  hueSlider.value = "120"

  controller.hueChanged()

  assert.equal(text.value, "#00ff00")
})

test("choosing a hue in the panel submits its six-digit hex", () => {
  const { controller, hueSlider, input } = pickerWith("#000000")
  controller.val = 1
  controller.sat = 1
  hueSlider.value = "240"

  controller.hueChanged()

  assert.equal(input.value, "#0000ff")
})

function browserReads(...colours) {
  globalThis.CSS = { supports: (property, value) => property === "color" && colours.includes(value) }
}

test("typing a colour the browser reads draws it in the swatch", () => {
  browserReads("oklch(0.62 0.19 259)")
  const { controller, text, swatch } = pickerWith("#000000")
  text.value = "oklch(0.62 0.19 259)"

  controller.textChanged()

  assert.equal(swatch.style.backgroundColor, "oklch(0.62 0.19 259)")
})

test("typing a colour the browser reads submits it exactly as typed", () => {
  browserReads("hsl(210 40% 50%)")
  const { controller, text, input } = pickerWith("#000000")
  text.value = "hsl(210 40% 50%)"

  controller.textChanged()

  assert.equal(input.value, "hsl(210 40% 50%)")
})

test("typing a colour the browser cannot read leaves the swatch and the submitted value as they were", () => {
  browserReads()
  const { controller, text, swatch, input } = pickerWith("#3b82f6")
  text.value = "red; background: url(x)"

  controller.textChanged()

  assert.deepEqual([ swatch.style.backgroundColor, input.value ], [ "#3b82f6", "#3b82f6" ])
})
