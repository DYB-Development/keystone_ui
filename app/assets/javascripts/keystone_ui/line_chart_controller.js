import { Controller } from "@hotwired/stimulus"

const loadChart = async () => {
  const { Chart, registerables } = await import("chart.js")
  Chart.register(...registerables)
  return Chart
}

const MILLISECONDS_IN_A_DAY = 86_400_000

export const dayLabel = (day) =>
  new Date(day * MILLISECONDS_IN_A_DAY).toLocaleDateString("en-US", { timeZone: "UTC", month: "short", day: "numeric", year: "numeric" })

export default class extends Controller {
  static targets = ["canvas"]
  static values = { data: Object }

  async connect() {
    const Chart = await loadChart()
    if (!this.element.isConnected) return

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
