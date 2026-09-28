export function keepPageThemeInStep(page = document) {
  page.addEventListener("turbo:before-render", ({ detail }) => {
    const next = detail.newBody.closest("html")
    if (!next) return

    for (const name of ["theme", "look"]) {
      const value = next.dataset[name]
      if (value) {
        page.documentElement.dataset[name] = value
      } else {
        delete page.documentElement.dataset[name]
      }
    }
  })
}
