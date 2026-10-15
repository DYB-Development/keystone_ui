import { Controller } from "@hotwired/stimulus"

const loadChart = async () => {
  const { Chart, registerables } = await import("chart.js")
  Chart.register(...registerables)
  return Chart
}

const MILLISECONDS_IN_A_DAY = 86_400_000

export const dayLabel = (day) =>
  new Date(day * MILLISECONDS_IN_A_DAY).toLocaleDateString("en-US", { timeZone: "UTC", month: "short", day: "numeric", year: "numeric" })

const DATED_AXIS = { type: "linear", bounds: "data" }
const DATED_TICKS = { precision: 0, callback: dayLabel }
const DATED_TOOLTIP = { callbacks: { title: ([point]) => dayLabel(point.parsed.x) } }

const tooltip = (theme) => ({
  backgroundColor: theme.surface,
  borderColor: theme.border,
  borderWidth: 1,
  titleColor: theme.text,
  bodyColor: theme.text
})

const DRAW_IN_MILLISECONDS = 600

const pointStep = (context) => DRAW_IN_MILLISECONDS / context.chart.data.datasets[context.datasetIndex].data.length

const drawsIn = (context) => context.type === "data" && context.mode === "default"

const drawIn = {
  x: {
    type: "number",
    easing: "linear",
    from: NaN,
    duration: (context) => (drawsIn(context) ? pointStep(context) : 0),
    delay: (context) => (drawsIn(context) ? context.index * pointStep(context) : 0)
  },
  y: { duration: 0 }
}

const axisText = (theme) => ({ color: theme.mutedText, font: { size: 11, family: theme.font } })

export const chartOptions = (dated, theme = {}, animated = false) => ({
  responsive: true,
  maintainAspectRatio: false,
  interaction: { mode: "index", intersect: false },
  ...(animated ? { animations: drawIn } : { animation: false }),
  elements: { line: { borderWidth: 1.5 }, point: { radius: 0, hoverRadius: 4 } },
  scales: {
    x: { ...(dated ? DATED_AXIS : {}), grid: { display: false }, ticks: { ...(dated ? DATED_TICKS : {}), ...axisText(theme) } },
    y: { border: { display: false }, grid: { color: theme.border }, ticks: axisText(theme) }
  },
  plugins: { tooltip: { ...(dated ? DATED_TOOLTIP : {}), ...tooltip(theme) } }
})

const LIGHT_THEMES = ["light", "custom"]

export const isDarkMode = (theme, prefersDark) => theme === "dark" || (prefersDark && !LIGHT_THEMES.includes(theme))

const CHART_COLOR_COUNT = 5

const INHERITED_FONTS = ["", "inherit"]

export const themeColors = (read, dark, inheritedFont) => {
  const variable = (name) => read(dark ? `${name}-dark` : name)
  const bodyFont = read("--ks-font-body")
  return {
    series: Array.from({ length: CHART_COLOR_COUNT }, (_, index) => variable(`--ks-color-chart-${index + 1}`)),
    border: variable("--ks-color-border"),
    surface: variable("--ks-color-surface"),
    text: variable("--ks-color-text"),
    mutedText: variable("--ks-color-text-muted"),
    font: INHERITED_FONTS.includes(bodyFont) ? inheritedFont : bodyFont
  }
}

export const styleDatasets = (datasets, theme, resolve) => {
  let uncolored = 0
  return datasets.map((dataset) => {
    const color = dataset.borderColor ? resolve(dataset.borderColor) : theme.series[uncolored++ % theme.series.length]
    return { ...dataset, borderColor: color, pointHoverBackgroundColor: color }
  })
}

export const watchTheme = ({ document, matchMedia, MutationObserver }, onChange) => {
  const observer = new MutationObserver(onChange)
  observer.observe(document.documentElement, { attributes: true, attributeFilter: ["data-theme", "data-look", "style"] })
  observer.observe(document.head, { childList: true, subtree: true, characterData: true })
  const darkPreference = matchMedia("(prefers-color-scheme: dark)")
  darkPreference.addEventListener("change", onChange)

  return () => {
    observer.disconnect()
    darkPreference.removeEventListener("change", onChange)
  }
}

export default class extends Controller {
  static targets = ["canvas"]
  static values = { data: Object, dated: Boolean }

  async connect() {
    const Chart = await loadChart()
    if (!this.element.isConnected) return

    const { theme, resolve } = this.readTheme()
    this.animated = !matchMedia("(prefers-reduced-motion: reduce)").matches
    this.chart = new Chart(this.canvasTarget, {
      type: "line",
      data: { ...this.dataValue, datasets: styleDatasets(this.dataValue.datasets, theme, resolve) },
      options: chartOptions(this.datedValue, theme, this.animated)
    })
    this.stopWatchingTheme = watchTheme({ document, matchMedia: (query) => matchMedia(query), MutationObserver }, () => this.redraw())
  }

  disconnect() {
    this.stopWatchingTheme?.()
    this.chart?.destroy()
  }

  redraw() {
    const { theme, resolve } = this.readTheme()
    const styled = styleDatasets(this.dataValue.datasets, theme, resolve)
    this.chart.data.datasets.forEach((dataset, index) => Object.assign(dataset, styled[index]))
    this.chart.options = chartOptions(this.datedValue, theme, this.animated)
    this.chart.update("none")
  }

  readTheme() {
    const styles = getComputedStyle(this.element)
    const read = (name) => styles.getPropertyValue(name).trim()
    const resolve = (color) => {
      const match = typeof color === "string" && color.match(/^var\((--[^)]+)\)$/)
      return match ? read(match[1]) || color : color
    }

    const dark = isDarkMode(document.documentElement.dataset.theme, matchMedia("(prefers-color-scheme: dark)").matches)
    return { theme: themeColors(read, dark, styles.fontFamily), resolve }
  }
}
