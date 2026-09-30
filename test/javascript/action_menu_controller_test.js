import { test } from "node:test"
import assert from "node:assert/strict"
import ActionMenuController from "../../app/assets/javascripts/keystone_ui/action_menu_controller.js"

function menuUnder(button) {
  const classes = new Set(["hidden"])
  const menu = {
    style: {},
    offsetWidth: 192,
    classList: {
      toggle: (name) => (classes.has(name) ? classes.delete(name) : classes.add(name)),
      add: (name) => classes.add(name),
      remove: (name) => classes.delete(name),
      contains: (name) => classes.has(name)
    }
  }
  const controller = new ActionMenuController({ scope: { element: { contains: () => false } } })
  Object.defineProperty(controller, "menuTarget", { value: menu })
  Object.defineProperty(controller, "buttonTarget", { value: { getBoundingClientRect: () => button } })
  return { controller, menu }
}

test("opening the menu places it on the screen just under its button, lined up with the button's right edge", () => {
  const { controller, menu } = menuUnder({ bottom: 300, right: 900 })

  controller.toggle({ stopPropagation() {} })

  assert.deepEqual([menu.style.position, menu.style.top, menu.style.left], ["fixed", "300px", "708px"])
})
