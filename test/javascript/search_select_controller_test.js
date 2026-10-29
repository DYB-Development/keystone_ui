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

function field({ matches = [], typed = "", newLabel = "" } = {}) {
  const requested = []
  globalThis.fetch = async (url) => {
    requested.push(url)
    return { json: async () => matches }
  }
  const controller = new SearchSelectController({ scope: { element: {} } })
  const targets = { id: element(), input: element({ value: typed }), list: element({ hidden: true }), newFields: element({ hidden: true }) }
  Object.defineProperty(controller, "idTarget", { value: targets.id })
  Object.defineProperty(controller, "inputTarget", { value: targets.input })
  Object.defineProperty(controller, "listTarget", { value: targets.list })
  Object.defineProperty(controller, "urlValue", { value: "/addresses/matches" })
  Object.defineProperty(controller, "newFieldsTarget", { value: targets.newFields })
  Object.defineProperty(controller, "hasNewFieldsTarget", { value: true })
  Object.defineProperty(controller, "newLabelValue", { value: newLabel })
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

test("picking a match shows it in the field and sets the id the form submits", async () => {
  const { controller, targets } = field({ typed: "main", matches: [{ id: 2, label: "400 Main St" }] })
  await controller.search()

  controller.choose({ params: { id: 2, label: "400 Main St" }, preventDefault() {} })

  assert.deepEqual([targets.id.value, targets.input.value, targets.list.classList.contains("hidden")], ["2", "400 Main St", true])
})

test("the list ends with the choice to enter a new record, and choosing it clears the id and shows the fields for it", async () => {
  const { controller, targets } = field({ typed: "elm", matches: [{ id: 2, label: "400 Main St" }], newLabel: "Enter a new address" })
  targets.id.value = "2"
  await controller.search()

  controller.chooseNew({ preventDefault() {} })

  assert.deepEqual([targets.list.innerHTML.includes("Enter a new address"), targets.id.value, targets.newFields.classList.contains("hidden")], [true, "", false])
})

test("picking a match after choosing to enter a new record hides the fields for the new record", async () => {
  const { controller, targets } = field({ typed: "main", matches: [{ id: 2, label: "400 Main St" }], newLabel: "Enter a new address" })
  await controller.search()
  controller.chooseNew({ preventDefault() {} })

  controller.choose({ params: { id: 2, label: "400 Main St" }, preventDefault() {} })

  assert.equal(targets.newFields.classList.contains("hidden"), true)
})

test("the down and up arrow keys move the highlighted match through the list", async () => {
  const { controller, targets } = field({ typed: "main", matches: [{ id: 2, label: "400 Main St" }, { id: 1, label: "12 Main St" }] })
  await controller.search()

  ;["ArrowDown", "ArrowDown", "ArrowUp"].forEach((key) => controller.key({ key, preventDefault() {} }))

  assert.deepEqual([...targets.list.innerHTML.matchAll(/aria-selected="true"[^>]*>([^<]+)</g)].map((match) => match[1]), ["400 Main St"])
})

test("Enter picks the highlighted match", async () => {
  const { controller, targets } = field({ typed: "main", matches: [{ id: 2, label: "400 Main St" }, { id: 1, label: "12 Main St" }] })
  await controller.search()
  ;["ArrowDown", "ArrowDown"].forEach((key) => controller.key({ key, preventDefault() {} }))

  controller.key({ key: "Enter", preventDefault() {} })

  assert.deepEqual([targets.id.value, targets.input.value], ["1", "12 Main St"])
})

test("Escape closes the list of matches", async () => {
  const { controller, targets } = field({ typed: "main", matches: [{ id: 2, label: "400 Main St" }] })
  await controller.search()

  controller.key({ key: "Escape", preventDefault() {} })

  assert.equal(targets.list.classList.contains("hidden"), true)
})

test("an arrow key pressed before anything is typed changes nothing", () => {
  const { controller, targets } = field()

  controller.key({ key: "ArrowDown", preventDefault() {} })

  assert.equal(targets.list.innerHTML, "")
})
