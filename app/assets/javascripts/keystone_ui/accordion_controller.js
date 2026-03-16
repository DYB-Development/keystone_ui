import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["answer", "icon"]

  toggle(event) {
    const index = event.currentTarget.dataset.index

    this.answerTargets.forEach((answer) => {
      if (answer.dataset.index === index) {
        answer.classList.toggle("hidden")
      }
    })

    this.iconTargets.forEach((icon) => {
      if (icon.dataset.index === index) {
        icon.classList.toggle("rotate-180")
      }
    })
  }
}
