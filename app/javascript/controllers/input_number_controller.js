import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["field"]

  append(event) {
    this.fieldTarget.value += event.target.textContent;
  }

  remove(event) {
    this.fieldTarget.value = this.fieldTarget.value.slice(0, -1);
  }
}
