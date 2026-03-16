import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "dropZone", "fileName"]

  connect() {
    this._onDragOver = this.dragOver.bind(this)
    this._onDragLeave = this.dragLeave.bind(this)
    this._onDrop = this.drop.bind(this)

    this.dropZoneTarget.addEventListener("dragover", this._onDragOver)
    this.dropZoneTarget.addEventListener("dragleave", this._onDragLeave)
    this.dropZoneTarget.addEventListener("drop", this._onDrop)
  }

  disconnect() {
    this.dropZoneTarget.removeEventListener("dragover", this._onDragOver)
    this.dropZoneTarget.removeEventListener("dragleave", this._onDragLeave)
    this.dropZoneTarget.removeEventListener("drop", this._onDrop)
  }

  dragOver(event) {
    event.preventDefault()
    this.dropZoneTarget.classList.add("border-accent-500", "bg-accent-50", "dark:bg-accent-900/10")
    this.dropZoneTarget.classList.remove("border-gray-300", "dark:border-zinc-600")
  }

  dragLeave(event) {
    event.preventDefault()
    this.dropZoneTarget.classList.remove("border-accent-500", "bg-accent-50", "dark:bg-accent-900/10")
    this.dropZoneTarget.classList.add("border-gray-300", "dark:border-zinc-600")
  }

  drop(event) {
    event.preventDefault()
    this.dragLeave(event)

    const files = event.dataTransfer.files
    if (files.length > 0) {
      this.inputTarget.files = files
      this.updateFileName()
    }
  }

  select() {
    this.updateFileName()
  }

  updateFileName() {
    if (!this.hasFileNameTarget) return

    const files = this.inputTarget.files
    if (files.length === 0) {
      this.fileNameTarget.textContent = ""
    } else if (files.length === 1) {
      this.fileNameTarget.textContent = files[0].name
    } else {
      this.fileNameTarget.textContent = `${files.length} files selected`
    }
  }
}
