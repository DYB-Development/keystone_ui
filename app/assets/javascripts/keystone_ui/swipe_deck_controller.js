import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "stack"]
  static values = { emptyTitle: String, emptySubtitle: String }

  connect() {
    this.currentIndex = 0
    this.setupTouch()
  }

  complete() {
    const card = this.currentCard
    if (!card) return

    const itemId = card.dataset.itemId
    const valueInput = card.querySelector("[data-swipe-deck-value]")
    const value = valueInput ? valueInput.value : null

    this.dispatch("complete", { detail: { itemId, value, card } })
    this.animateOut(card, "right", "ring-2 ring-green-400")
  }

  skip() {
    const card = this.currentCard
    if (!card) return

    const itemId = card.dataset.itemId
    this.dispatch("skip", { detail: { itemId, card } })
    this.animateOut(card, "left", "ring-2 ring-red-400")
  }

  get currentCard() {
    return this.cardTargets[this.currentIndex]
  }

  animateOut(card, direction, colorClass) {
    if (colorClass) {
      colorClass.split(" ").forEach(c => card.classList.add(c))
    }
    const translateX = direction === "right" ? "150%" : "-150%"
    const rotate = direction === "right" ? "15" : "-15"
    card.style.transition = "transform 0.3s ease-out, opacity 0.3s ease-out"
    card.style.transform = `translateX(${translateX}) rotate(${rotate}deg)`
    card.style.opacity = "0"

    setTimeout(() => {
      card.style.display = "none"
      this.currentIndex++
      this.updateStack()
    }, 300)
  }

  updateStack() {
    const remaining = this.cardTargets.slice(this.currentIndex)
    remaining.forEach((card, index) => {
      card.style.transition = "transform 0.3s ease-out"
      card.style.transform = `scale(${1 - index * 0.05}) translateY(${index * 8}px)`
      card.style.zIndex = remaining.length - index
    })

    if (remaining.length === 0) {
      const title = this.emptyTitleValue || "All done!"
      const subtitle = this.emptySubtitleValue
      let html = `
        <div class="text-center py-16" data-testid="swipe-empty">
          <p class="text-2xl font-semibold text-gray-900 dark:text-white">${title}</p>`
      if (subtitle) {
        html += `
          <p class="mt-2 text-gray-500 dark:text-gray-400">${subtitle}</p>`
      }
      html += `
        </div>`
      this.stackTarget.innerHTML = html
    }
  }

  clearSwipeColor(card) {
    card.classList.remove("ring-2", "ring-green-400", "ring-red-400")
  }

  setupTouch() {
    let startX = 0
    let currentX = 0

    const isInput = (e) => e.target.closest("input, textarea, select")

    this.element.addEventListener("touchstart", (e) => {
      if (isInput(e)) return
      startX = e.touches[0].clientX
    })

    this.element.addEventListener("touchmove", (e) => {
      if (isInput(e) || !this.currentCard) return
      currentX = e.touches[0].clientX
      const diff = currentX - startX
      this.currentCard.style.transition = "none"
      this.currentCard.style.transform = `translateX(${diff}px) rotate(${diff * 0.1}deg)`
      this.clearSwipeColor(this.currentCard)
      if (Math.abs(diff) > 30) {
        this.currentCard.classList.add("ring-2", diff > 0 ? "ring-green-400" : "ring-red-400")
      }
    })

    this.element.addEventListener("touchend", (e) => {
      if (isInput(e) || !this.currentCard) return
      const diff = currentX - startX
      if (Math.abs(diff) > 100) {
        if (diff > 0) {
          this.complete()
        } else {
          this.skip()
        }
      } else {
        this.clearSwipeColor(this.currentCard)
        this.currentCard.style.transition = "transform 0.3s ease-out"
        this.currentCard.style.transform = ""
      }
      startX = 0
      currentX = 0
    })
  }
}
