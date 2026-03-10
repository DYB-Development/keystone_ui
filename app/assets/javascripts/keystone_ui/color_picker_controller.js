import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["swatch", "hexLabel", "input", "panel", "svArea", "svGradient", "svCursor", "hueSlider"]
  static values = { value: String }

  connect() {
    this.hue = 0
    this.sat = 1
    this.val = 1
    this.dragging = false

    if (this.valueValue) {
      this.setFromHex(this.valueValue)
    }

    this.boundPointerMove = this.svMove.bind(this)
    this.boundPointerUp = this.svUp.bind(this)
    this.boundClickOutside = this.clickOutside.bind(this)
  }

  disconnect() {
    document.removeEventListener("pointermove", this.boundPointerMove)
    document.removeEventListener("pointerup", this.boundPointerUp)
    document.removeEventListener("click", this.boundClickOutside)
  }

  toggle(event) {
    event.stopPropagation()
    const panel = this.panelTarget
    const isHidden = panel.classList.contains("hidden")

    if (isHidden) {
      panel.classList.remove("hidden")
      document.addEventListener("click", this.boundClickOutside)
    } else {
      this.close()
    }
  }

  close() {
    this.panelTarget.classList.add("hidden")
    document.removeEventListener("click", this.boundClickOutside)
  }

  clickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }

  hueChanged() {
    this.hue = parseInt(this.hueSliderTarget.value)
    this.updateSvGradient()
    this.updateColor()
  }

  svDown(event) {
    event.preventDefault()
    this.dragging = true
    document.addEventListener("pointermove", this.boundPointerMove)
    document.addEventListener("pointerup", this.boundPointerUp)
    this.updateSvFromPointer(event)
  }

  svMove(event) {
    if (!this.dragging) return
    event.preventDefault()
    this.updateSvFromPointer(event)
  }

  svUp() {
    this.dragging = false
    document.removeEventListener("pointermove", this.boundPointerMove)
    document.removeEventListener("pointerup", this.boundPointerUp)
  }

  updateSvFromPointer(event) {
    const rect = this.svAreaTarget.getBoundingClientRect()
    const x = Math.max(0, Math.min(event.clientX - rect.left, rect.width))
    const y = Math.max(0, Math.min(event.clientY - rect.top, rect.height))

    this.sat = x / rect.width
    this.val = 1 - y / rect.height

    this.svCursorTarget.style.left = `${(this.sat * 100)}%`
    this.svCursorTarget.style.top = `${((1 - this.val) * 100)}%`

    this.updateColor()
  }

  updateColor() {
    const hex = this.hsvToHex(this.hue, this.sat, this.val)
    this.swatchTarget.style.backgroundColor = hex
    this.hexLabelTarget.textContent = hex
    this.inputTarget.value = hex

    this.inputTarget.dispatchEvent(new Event("change", { bubbles: true }))
  }

  updateSvGradient() {
    const hueColor = `hsl(${this.hue}, 100%, 50%)`
    this.svGradientTarget.style.background = `linear-gradient(to right, #fff, ${hueColor})`
  }

  setFromHex(hex) {
    const { h, s, v } = this.hexToHsv(hex)
    this.hue = h
    this.sat = s
    this.val = v

    if (this.hasHueSliderTarget) this.hueSliderTarget.value = h
    this.updateSvGradient()

    if (this.hasSvCursorTarget) {
      this.svCursorTarget.style.left = `${(s * 100)}%`
      this.svCursorTarget.style.top = `${((1 - v) * 100)}%`
    }
  }

  hsvToHex(h, s, v) {
    const c = v * s
    const x = c * (1 - Math.abs(((h / 60) % 2) - 1))
    const m = v - c
    let r, g, b

    if (h < 60) { r = c; g = x; b = 0 }
    else if (h < 120) { r = x; g = c; b = 0 }
    else if (h < 180) { r = 0; g = c; b = x }
    else if (h < 240) { r = 0; g = x; b = c }
    else if (h < 300) { r = x; g = 0; b = c }
    else { r = c; g = 0; b = x }

    const toHex = (n) => Math.round((n + m) * 255).toString(16).padStart(2, "0")
    return `#${toHex(r)}${toHex(g)}${toHex(b)}`
  }

  hexToHsv(hex) {
    const r = parseInt(hex.slice(1, 3), 16) / 255
    const g = parseInt(hex.slice(3, 5), 16) / 255
    const b = parseInt(hex.slice(5, 7), 16) / 255

    const max = Math.max(r, g, b)
    const min = Math.min(r, g, b)
    const d = max - min

    let h = 0
    if (d !== 0) {
      if (max === r) h = 60 * (((g - b) / d) % 6)
      else if (max === g) h = 60 * ((b - r) / d + 2)
      else h = 60 * ((r - g) / d + 4)
    }
    if (h < 0) h += 360

    const s = max === 0 ? 0 : d / max
    return { h: Math.round(h), s, v: max }
  }
}
