export function keepPageThemeInStep(page = document) {
  page.addEventListener("turbo:before-render", ({ detail }) => {
    const next = detail.newBody.closest("html")
    if (!next) return

    page.documentElement.dataset.theme = next.dataset.theme
  })
}
