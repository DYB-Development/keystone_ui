import { test } from "node:test"
import assert from "node:assert/strict"
import ActionMenuController from "../../app/assets/javascripts/keystone_ui/action_menu_controller.js"

function menuUnder(button, { screenHeight = 800, menuHeight = 120 } = {}) {
  const classes = new Set(["hidden"])
  const menu = {
    style: {},
    offsetWidth: 192,
    offsetHeight: menuHeight,
    classList: {
      toggle: (name) => (classes.has(name) ? classes.delete(name) : classes.add(name)),
      add: (name) => classes.add(name),
      remove: (name) => classes.delete(name),
      contains: (name) => classes.has(name)
    }
  }
  const controller = new ActionMenuController({ scope: { element: { contains: () => false, ownerDocument: { documentElement: { clientHeight: screenHeight } } } } })
  Object.defineProperty(controller, "menuTarget", { value: menu })
  Object.defineProperty(controller, "buttonTarget", { value: { getBoundingClientRect: () => button } })
  return { controller, menu }
}

test("opening the menu places it on the screen just under its button, lined up with the button's right edge", () => {
  const { controller, menu } = menuUnder({ bottom: 300, right: 900 })

  controller.toggle({ stopPropagation() {} })

  assert.deepEqual([menu.style.position, menu.style.top, menu.style.left], ["fixed", "300px", "708px"])
})

test("opening a menu with no room under its button places it just above the button", () => {
  const { controller, menu } = menuUnder({ top: 740, bottom: 770, right: 900 }, { screenHeight: 800, menuHeight: 120 })

  controller.toggle({ stopPropagation() {} })

  assert.equal(menu.style.top, "620px")
})

test("opening a menu with room neither under nor above its button places it at the top of the screen", () => {
  const { controller, menu } = menuUnder({ top: 100, bottom: 130, right: 900 }, { screenHeight: 200, menuHeight: 180 })

  controller.toggle({ stopPropagation() {} })

  assert.equal(menu.style.top, "0px")
})

test("closing the menu hides it, as when the page scrolls under it", () => {
  const { controller, menu } = menuUnder({ bottom: 300, right: 900 })
  controller.toggle({ stopPropagation() {} })

  controller.close()

  assert.equal(menu.classList.contains("hidden"), true)
})
