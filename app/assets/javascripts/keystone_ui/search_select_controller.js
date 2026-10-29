import { Controller } from "@hotwired/stimulus"

const escaped = (text) => String(text).replace(/[&<>"']/g, (character) => `&#${character.charCodeAt(0)};`)

export default class extends Controller {
  static targets = ["id", "input", "list", "newFields"]
  static values = { url: String, newLabel: String }

  async search() {
    const response = await fetch(`${this.urlValue}?q=${encodeURIComponent(this.inputTarget.value)}`, { headers: { Accept: "application/json" } })
    this.matches = await response.json()
    this.highlighted = -1
    this.draw()
    this.listTarget.classList.remove("hidden")
  }

  key(event) {
    if (event.key === "Enter") return this.pickHighlighted(event)

    const moves = { ArrowDown: 1, ArrowUp: -1 }
    if (!(event.key in moves)) return

    event.preventDefault()
    this.highlighted = Math.min(Math.max(this.highlighted + moves[event.key], 0), this.choiceCount() - 1)
    this.draw()
  }

  pickHighlighted(event) {
    if (this.highlighted === undefined || this.highlighted < 0) return

    const match = this.matches[this.highlighted]
    if (match) this.choose({ params: match, preventDefault: () => event.preventDefault() })
    else this.chooseNew(event)
  }

  draw() {
    this.listTarget.innerHTML = this.matches.map((match, index) => this.option(match, index === this.highlighted)).join("") + this.newOption(this.highlighted === this.matches.length)
  }

  choiceCount() {
    return this.matches.length + (this.newLabelValue ? 1 : 0)
  }

  choose(event) {
    event.preventDefault()
    this.idTarget.value = String(event.params.id)
    this.inputTarget.value = event.params.label
    if (this.hasNewFieldsTarget) this.newFieldsTarget.classList.add("hidden")
    this.listTarget.classList.add("hidden")
  }

  chooseNew(event) {
    event.preventDefault()
    this.idTarget.value = ""
    if (this.hasNewFieldsTarget) this.newFieldsTarget.classList.remove("hidden")
    this.listTarget.classList.add("hidden")
  }

  newOption(highlighted = false) {
    if (!this.newLabelValue) return ""

    return `<li role="option" class="ks-menu-option" data-action="mousedown->search-select#chooseNew" aria-selected="${highlighted}">${escaped(this.newLabelValue)}</li>`
  }

  option(match, highlighted = false) {
    return `<li role="option" class="ks-menu-option" data-action="mousedown->search-select#choose" data-search-select-id-param="${escaped(match.id)}" data-search-select-label-param="${escaped(match.label)}" aria-selected="${highlighted}">${escaped(match.label)}</li>`
  }
}
