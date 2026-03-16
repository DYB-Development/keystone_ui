import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["backdrop"]

  open() {
    this.backdropTarget.classList.remove("hidden")
  }

  close() {
    this.backdropTarget.classList.add("hidden")
  }

  closeOnBackdrop(event) {
    if (event.target === this.backdropTarget) {
      this.close()
    }
  }
}
