import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    this.layout()
  }

  layout(event) {
    // Get the initial dimensions of the container
    const container = this.element
    const viewportHeight = window.innerHeight
    const viewportWidth = window.innerWidth
    const aspectRatioWidth = (9 / 16) * viewportHeight
    const aspectRatioHeight = (16 / 9) * viewportWidth

    // Set the dimensions of the container
    if (viewportHeight < aspectRatioHeight) {
      container.style.width = `${aspectRatioWidth}px`
      container.style.height = `${viewportHeight}px`
    } else {
      container.style.width = `${viewportWidth}px`
      container.style.height = `${aspectRatioHeight}px`
    }

    // Set the root font size
    const root = document.documentElement
    root.style.fontSize = `${container.offsetHeight * 0.03}px`
  }
}
