import { Controller } from "@hotwired/stimulus"

const escaped = (text) => String(text).replace(/[&<>"']/g, (character) => `&#${character.charCodeAt(0)};`)

export default class extends Controller {
  static targets = ["id", "input", "list", "newFields"]
  static values = { url: String, newLabel: String }

  async search() {
    const response = await fetch(`${this.urlValue}?q=${encodeURIComponent(this.inputTarget.value)}`, { headers: { Accept: "application/json" } })
    this.matches = await response.json()
    this.listTarget.innerHTML = this.matches.map((match) => this.option(match)).join("") + this.newOption()
    this.listTarget.classList.remove("hidden")
  }

  choose(event) {
    event.preventDefault()
    this.idTarget.value = String(event.params.id)
    this.inputTarget.value = event.params.label
    this.listTarget.classList.add("hidden")
  }

  chooseNew(event) {
    event.preventDefault()
    this.idTarget.value = ""
    if (this.hasNewFieldsTarget) this.newFieldsTarget.classList.remove("hidden")
    this.listTarget.classList.add("hidden")
  }

  newOption() {
    if (!this.newLabelValue) return ""

    return `<li role="option" class="ks-menu-option" data-action="mousedown->search-select#chooseNew">${escaped(this.newLabelValue)}</li>`
  }

  option(match) {
    return `<li role="option" class="ks-menu-option" data-action="mousedown->search-select#choose" data-search-select-id-param="${escaped(match.id)}" data-search-select-label-param="${escaped(match.label)}">${escaped(match.label)}</li>`
  }
}
