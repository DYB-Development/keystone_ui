import { test } from "node:test"
import assert from "node:assert/strict"
import FileUploadController from "../../app/assets/javascripts/keystone_ui/file_upload_controller.js"

function controllerWithDropZone() {
  const dropZone = { classList: new DOMTokenListDouble() }
  const controller = new FileUploadController({ scope: { element: {} } })
  Object.defineProperty(controller, "dropZoneTarget", { value: dropZone })
  return { controller, dropZone }
}

class DOMTokenListDouble {
  constructor() { this.tokens = new Set() }
  add(...names) { names.forEach((name) => this.tokens.add(name)) }
  remove(...names) { names.forEach((name) => this.tokens.delete(name)) }
  contains(name) { return this.tokens.has(name) }
}

const dragEvent = { preventDefault() {} }

test("dragging a file over the drop zone marks it active", () => {
  const { controller, dropZone } = controllerWithDropZone()

  controller.dragOver(dragEvent)

  assert.equal(dropZone.classList.contains("ks-file-upload-drop-zone-active"), true)
})
