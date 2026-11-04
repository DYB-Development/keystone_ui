import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["row", "control", "status"]

  connect() {
    this.controlTargets.forEach((control) => { control.hidden = false })
  }
}
