export function keepPageThemeInStep(page = document) {
  page.addEventListener("turbo:before-render", ({ detail }) => {
    const next = detail.newBody.closest("html")
    if (!next) return

    const theme = next.dataset.theme
    if (theme) {
      page.documentElement.dataset.theme = theme
    } else {
      delete page.documentElement.dataset.theme
    }
  })
}
