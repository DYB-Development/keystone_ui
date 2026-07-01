import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js"

Chart.register(...registerables)

export default class extends Controller {
  static targets = ["canvas"]
  static values = { data: Object }

  connect() {
    this.chart = new Chart(this.canvasTarget, {
      type: "line",
      data: this.resolveColors(this.dataValue),
      options: {
        responsive: true,
        maintainAspectRatio: false,
        interaction: { mode: "index", intersect: false }
      }
    })
  }

  disconnect() {
    this.chart?.destroy()
  }

  resolveColors(data) {
    const styles = getComputedStyle(this.element)
    const resolve = (color) => {
      const match = typeof color === "string" && color.match(/^var\((--[^)]+)\)$/)
      return match ? styles.getPropertyValue(match[1]).trim() || color : color
    }

    data.datasets.forEach((dataset) => {
      if (dataset.borderColor) dataset.borderColor = resolve(dataset.borderColor)
    })
    return data
  }
}
