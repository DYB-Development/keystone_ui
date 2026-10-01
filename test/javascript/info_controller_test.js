import { test } from "node:test"
import assert from "node:assert/strict"
import InfoController from "../../app/assets/javascripts/keystone_ui/info_controller.js"

function element(width) {
  const classes = new Set(["hidden"])
  return {
    style: {},
    offsetWidth: width,
    classList: {
      toggle: (name) => (classes.has(name) ? classes.delete(name) : classes.add(name)),
      add: (name) => classes.add(name),
      remove: (name) => classes.delete(name),
      contains: (name) => classes.has(name)
    }
  }
}

function infoAt(button, { detail = true } = {}) {
  const summary = element(256)
  const panel = detail ? element(288) : null
  const controller = new InfoController({ scope: { element: { contains: () => false } } })
  Object.defineProperty(controller, "buttonTarget", { value: { getBoundingClientRect: () => button } })
  Object.defineProperty(controller, "summaryTarget", { value: summary })
  Object.defineProperty(controller, "hasDetailTarget", { value: detail })
  if (detail) Object.defineProperty(controller, "detailTarget", { value: panel })
  return { controller, summary, panel }
}

test("hovering the button shows its summary on the screen just under it, lined up with its right edge", () => {
  const { controller, summary } = infoAt({ bottom: 300, right: 900 })

  controller.peek()

  assert.deepEqual([summary.classList.contains("hidden"), summary.style.position, summary.style.top, summary.style.left], [false, "fixed", "300px", "644px"])
})

test("moving off the button hides its summary again", () => {
  const { controller, summary } = infoAt({ bottom: 300, right: 900 })
  controller.peek()

  controller.unpeek()

  assert.equal(summary.classList.contains("hidden"), true)
})

test("clicking the button opens its detail on the screen just under it", () => {
  const { controller, panel } = infoAt({ bottom: 300, right: 900 })

  controller.toggle({ stopPropagation() {} })

  assert.deepEqual([panel.classList.contains("hidden"), panel.style.position, panel.style.top, panel.style.left], [false, "fixed", "300px", "612px"])
})
