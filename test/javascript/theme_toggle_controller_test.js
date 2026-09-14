import { test } from "node:test"
import assert from "node:assert/strict"
import ThemeToggleController from "../../app/assets/javascripts/keystone_ui/theme_toggle_controller.js"

function toggleOn(page, options = []) {
  const element = { ownerDocument: page, querySelectorAll: () => options }
  return new ThemeToggleController({ scope: { element } })
}

function option(mode) {
  return { dataset: { themeToggleModeParam: mode }, setAttribute(name, value) { this[name] = value } }
}

function pageWithNoChoice() {
  return { documentElement: { dataset: {} }, cookie: "" }
}

test("choosing dark marks the page dark", () => {
  const page = pageWithNoChoice()

  toggleOn(page).choose({ params: { mode: "dark" } })

  assert.equal(page.documentElement.dataset.theme, "dark")
})

test("choosing dark remembers the choice in the theme cookie for a year", () => {
  const page = pageWithNoChoice()

  toggleOn(page).choose({ params: { mode: "dark" } })

  assert.equal(page.cookie, "keystone_theme=dark; path=/; max-age=31536000; samesite=lax")
})

test("choosing system removes the page's light or dark mark", () => {
  const page = pageWithNoChoice()
  page.documentElement.dataset.theme = "dark"

  toggleOn(page).choose({ params: { mode: "system" } })

  assert.equal("theme" in page.documentElement.dataset, false)
})

test("choosing system remembers the choice in the theme cookie for a year", () => {
  const page = pageWithNoChoice()

  toggleOn(page).choose({ params: { mode: "system" } })

  assert.equal(page.cookie, "keystone_theme=system; path=/; max-age=31536000; samesite=lax")
})

test("choosing dark shows only the dark option as pressed", () => {
  const options = ["light", "dark", "system"].map(option)

  toggleOn(pageWithNoChoice(), options).choose({ params: { mode: "dark" } })

  assert.deepEqual(options.map((o) => o["aria-pressed"]), ["false", "true", "false"])
})
