import { test } from "node:test"
import assert from "node:assert/strict"
import { keepPageThemeInStep } from "../../app/assets/javascripts/keystone_ui/page_theme.js"

function pageMarked(theme) {
  const page = { documentElement: { dataset: {} }, listeners: {} }
  if (theme) page.documentElement.dataset.theme = theme
  page.addEventListener = (name, listener) => { page.listeners[name] = listener }
  return page
}

function renderTurboPage(page, theme) {
  const next = { dataset: theme ? { theme } : {} }
  page.listeners["turbo:before-render"]({ detail: { newBody: { closest: () => next } } })
}

test("a page Turbo shows next marks the page with its theme", () => {
  const page = pageMarked("light")
  keepPageThemeInStep(page)

  renderTurboPage(page, "custom")

  assert.equal(page.documentElement.dataset.theme, "custom")
})
