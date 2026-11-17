import { test } from "node:test"
import assert from "node:assert/strict"
import TabSwitcherController from "../../app/assets/javascripts/keystone_ui/tab_switcher_controller.js"

function switcherWithPanels() {
  const tabs = [0, 1].map((index) => ({ dataset: { index: String(index) }, setAttribute() {}, removeAttribute() {} }))
  const panels = [{ hidden: false, disabled: false }, { hidden: true, disabled: true }]
  const controller = new TabSwitcherController({ scope: { element: {} } })
  Object.defineProperty(controller, "tabTargets", { value: tabs })
  Object.defineProperty(controller, "panelTargets", { value: panels })
  controller.dispatch = () => {}
  return { controller, tabs, panels }
}

test("choosing the second tab shows its panel and hides the first", () => {
  const { controller, tabs, panels } = switcherWithPanels()

  controller.select({ currentTarget: tabs[1] })

  assert.deepEqual(panels.map((panel) => panel.hidden), [true, false])
})

test("choosing the second tab disables the fields of the first panel and enables its own", () => {
  const { controller, tabs, panels } = switcherWithPanels()

  controller.select({ currentTarget: tabs[1] })

  assert.deepEqual(panels.map((panel) => panel.disabled), [true, false])
})
