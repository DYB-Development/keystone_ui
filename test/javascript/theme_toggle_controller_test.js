import { test } from "node:test"
import assert from "node:assert/strict"
import ThemeToggleController from "../../app/assets/javascripts/keystone_ui/theme_toggle_controller.js"

function toggleOn(page) {
  return new ThemeToggleController({ scope: { element: { ownerDocument: page } } })
}

function pageMarked(theme, { deviceDark = false } = {}) {
  const dataset = theme ? { theme } : {}
  return { documentElement: { dataset }, cookie: "", defaultView: { matchMedia: () => ({ matches: deviceDark }) } }
}

test("pressing the toggle on a page marked light marks it dark", () => {
  const page = pageMarked("light")

  toggleOn(page).toggle()

  assert.equal(page.documentElement.dataset.theme, "dark")
})
