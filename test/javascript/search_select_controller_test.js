import { test } from "node:test"
import assert from "node:assert/strict"
import SearchSelectController from "../../app/assets/javascripts/keystone_ui/search_select_controller.js"

function element(properties = {}) {
  const classes = new Set(properties.hidden ? ["hidden"] : [])
  return {
    value: "",
    innerHTML: "",
    ...properties,
    classList: {
      add: (name) => classes.add(name),
      remove: (name) => classes.delete(name),
      contains: (name) => classes.has(name)
    }
  }
}

function field({ matches = [], typed = "" } = {}) {
  const requested = []
  globalThis.fetch = async (url) => {
    requested.push(url)
    return { json: async () => matches }
  }
  const controller = new SearchSelectController({ scope: { element: {} } })
  const targets = { id: element(), input: element({ value: typed }), list: element({ hidden: true }) }
  Object.defineProperty(controller, "idTarget", { value: targets.id })
  Object.defineProperty(controller, "inputTarget", { value: targets.input })
  Object.defineProperty(controller, "listTarget", { value: targets.list })
  Object.defineProperty(controller, "urlValue", { value: "/addresses/matches" })
  return { controller, targets, requested }
}

test("typing lists the matches the host returns, in the host's order", async () => {
  const { controller, targets } = field({ typed: "main", matches: [{ id: 2, label: "400 Main St" }, { id: 1, label: "12 Main St" }] })

  await controller.search()

  assert.deepEqual([...targets.list.innerHTML.matchAll(/">([^<]+)<\/li>/g)].map((match) => match[1]), ["400 Main St", "12 Main St"])
})

test("a match's label is listed as text, not as markup", async () => {
  const { controller, targets } = field({ typed: "yard", matches: [{ id: 3, label: "<b>Yard</b>" }] })

  await controller.search()

  assert.equal(targets.list.innerHTML.includes("<b>"), false)
})
