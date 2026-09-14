import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  choose({ params: { mode } }) {
    this.element.ownerDocument.documentElement.dataset.theme = mode
  }
}
