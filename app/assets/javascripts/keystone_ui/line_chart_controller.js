import { Controller } from "@hotwired/stimulus"

const loadChart = async () => {
  const { Chart, registerables } = await import("chart.js")
  Chart.register(...registerables)
  return Chart
}

const MILLISECONDS_IN_A_DAY = 86_400_000

export const dayLabel = (day) =>
  new Date(day * MILLISECONDS_IN_A_DAY).toLocaleDateString("en-US", { timeZone: "UTC", month: "short", day: "numeric", year: "numeric" })

const DATED_OPTIONS = {
  scales: { x: { type: "linear", ticks: { precision: 0, callback: dayLabel } } },
  plugins: { tooltip: { callbacks: { title: ([point]) => dayLabel(point.parsed.x) } } }
}

export const chartOptions = (dated) => ({
  responsive: true,
  maintainAspectRatio: false,
  interaction: { mode: "index", intersect: false },
  ...(dated ? DATED_OPTIONS : {})
})

export default class extends Controller {
  static targets = ["canvas"]
  static values = { data: Object, dated: Boolean }

  async connect() {
    const Chart = await loadChart()
    if (!this.element.isConnected) return

    this.chart = new Chart(this.canvasTarget, {
      type: "line",
      data: this.resolveColors(this.dataValue),
      options: chartOptions(this.datedValue)
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
