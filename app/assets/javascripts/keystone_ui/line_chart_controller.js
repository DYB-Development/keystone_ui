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
  scales: { x: { type: "linear", bounds: "data", ticks: { precision: 0, callback: dayLabel } } },
  plugins: { tooltip: { callbacks: { title: ([point]) => dayLabel(point.parsed.x) } } }
}

export const chartOptions = (dated) => ({
  responsive: true,
  maintainAspectRatio: false,
  interaction: { mode: "index", intersect: false },
  elements: { line: { borderWidth: 1.5 }, point: { radius: 0, hoverRadius: 4 } },
  ...(dated ? DATED_OPTIONS : {})
})

const CHART_COLOR_COUNT = 5

export const themeColors = (read, dark) => {
  const variable = (name) => read(dark ? `${name}-dark` : name)
  return {
    series: Array.from({ length: CHART_COLOR_COUNT }, (_, index) => variable(`--ks-color-chart-${index + 1}`))
  }
}

export const styleDatasets = (datasets, theme, resolve) => {
  let uncolored = 0
  return datasets.map((dataset) => {
    const color = dataset.borderColor ? resolve(dataset.borderColor) : theme.series[uncolored++ % theme.series.length]
    return { ...dataset, borderColor: color, pointHoverBackgroundColor: color }
  })
}

export default class extends Controller {
  static targets = ["canvas"]
  static values = { data: Object, dated: Boolean }

  async connect() {
    const Chart = await loadChart()
    if (!this.element.isConnected) return

    this.chart = new Chart(this.canvasTarget, {
      type: "line",
      data: this.styledData(),
      options: chartOptions(this.datedValue)
    })
  }

  disconnect() {
    this.chart?.destroy()
  }

  styledData() {
    const styles = getComputedStyle(this.element)
    const read = (name) => styles.getPropertyValue(name).trim()
    const resolve = (color) => {
      const match = typeof color === "string" && color.match(/^var\((--[^)]+)\)$/)
      return match ? read(match[1]) || color : color
    }

    return { ...this.dataValue, datasets: styleDatasets(this.dataValue.datasets, themeColors(read, false), resolve) }
  }
}
