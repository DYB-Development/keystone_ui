import { test } from "node:test"
import assert from "node:assert/strict"
import DropdownController from "../../app/assets/javascripts/keystone_ui/dropdown_controller.js"

function openMenu() {
  const classes = new Set()
  const menu = {
    classList: {
      toggle: (name) => (classes.has(name) ? classes.delete(name) : classes.add(name)),
      add: (name) => classes.add(name),
      contains: (name) => classes.has(name)
    }
  }
  const controller = new DropdownController({ scope: { element: { contains: () => false } } })
  Object.defineProperty(controller, "menuTarget", { value: menu })
  return { controller, menu }
}

test("clicking the button of an open menu hides the menu so it collapses", () => {
  const { controller, menu } = openMenu()

  controller.toggle({ stopPropagation() {} })

  assert.equal(menu.classList.contains("hidden"), true)
})
