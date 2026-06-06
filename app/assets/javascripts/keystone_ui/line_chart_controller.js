import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js"

Chart.register(...registerables)

export default class extends Controller {
  static targets = ["canvas"]
  static values = { data: Object }

  connect() {
    this.chart = new Chart(this.canvasTarget, {
      type: "line",
      data: this.dataValue,
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
}
