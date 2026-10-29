import { Controller } from "@hotwired/stimulus"

const escaped = (text) => String(text).replace(/[&<>"']/g, (character) => `&#${character.charCodeAt(0)};`)

export default class extends Controller {
  static targets = ["id", "input", "list"]
  static values = { url: String }

  async search() {
    const response = await fetch(`${this.urlValue}?q=${encodeURIComponent(this.inputTarget.value)}`, { headers: { Accept: "application/json" } })
    this.matches = await response.json()
    this.listTarget.innerHTML = this.matches.map((match) => this.option(match)).join("")
    this.listTarget.classList.remove("hidden")
  }

  option(match) {
    return `<li role="option" class="ks-menu-option" data-action="mousedown->search-select#choose" data-search-select-id-param="${escaped(match.id)}" data-search-select-label-param="${escaped(match.label)}">${escaped(match.label)}</li>`
  }
}
