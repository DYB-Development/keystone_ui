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
  Object.defineProperty(controller, "buttonTarget", { value: { getBoundingClientRect: () => button }, configurable: true })
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

test("tapping a button that holds only a summary shows the summary", () => {
  const { controller, summary } = infoAt({ bottom: 300, right: 900 }, { detail: false })

  controller.toggle({ stopPropagation() {} })

  assert.deepEqual([summary.classList.contains("hidden"), summary.style.position], [false, "fixed"])
})

test("a click anywhere else closes the detail", () => {
  const { controller, panel } = infoAt({ bottom: 300, right: 900 })
  controller.toggle({ stopPropagation() {} })

  controller.hide({ target: {} })

  assert.equal(panel.classList.contains("hidden"), true)
})

test("a popup near the left edge of the screen stays on the screen", () => {
  const { controller, summary } = infoAt({ bottom: 300, right: 40 })

  controller.peek()

  assert.equal(summary.style.left, "8px")
})

test("scrolling the page closes its popups, which would otherwise float in place", () => {
  const { controller, summary, panel } = infoAt({ bottom: 300, right: 900 })
  controller.peek()
  controller.toggle({ stopPropagation() {} })

  controller.close()

  assert.deepEqual([summary.classList.contains("hidden"), panel.classList.contains("hidden")], [true, true])
})

test("the first time a popup opens it is measured where it will show, not where it sat in the page", () => {
  const { controller, summary } = infoAt({ bottom: 300, right: 900 })
  Object.defineProperty(summary, "offsetWidth", { get: () => (summary.style.position === "fixed" ? 256 : 1200) })

  controller.peek()

  assert.equal(summary.style.left, "644px")
})

test("the button is measured after its popup leaves the page's layout, so revealing the popup cannot move the button first", () => {
  const { controller, summary } = infoAt({ bottom: 300, right: 900 })
  const inLayout = () => !summary.classList.contains("hidden") && summary.style.position !== "fixed"
  Object.defineProperty(controller, "buttonTarget", { value: { getBoundingClientRect: () => (inLayout() ? { bottom: 358, right: 644 } : { bottom: 300, right: 900 }) } })

  controller.peek()

  assert.deepEqual([summary.style.top, summary.style.left], ["300px", "644px"])
})
