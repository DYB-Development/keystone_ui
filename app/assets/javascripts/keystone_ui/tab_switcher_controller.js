import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  select(event) {
    const index = parseInt(event.currentTarget.dataset.index)

    this.tabTargets.forEach((tab) => {
      if (parseInt(tab.dataset.index) === index) {
        tab.setAttribute("data-active", "")
      } else {
        tab.removeAttribute("data-active")
      }
    })

    this.panelTargets.forEach((panel, panelIndex) => {
      panel.hidden = panelIndex !== index
    })

    this.dispatch("change", { detail: { index } })
  }
}
