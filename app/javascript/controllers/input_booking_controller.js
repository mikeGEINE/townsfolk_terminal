import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["field"]

  append(event) {
    this.fieldTarget.value += event.target.textContent;
    if (this.fieldTarget.value.length === 5) {
      this.fieldTarget.value += '-';
    }
  }

  remove(event) {
    if (this.fieldTarget.value[this.fieldTarget.value.length - 1] === '-') {
      this.fieldTarget.value = this.fieldTarget.value.slice(0, -1);
    }
    this.fieldTarget.value = this.fieldTarget.value.slice(0, -1);
  }
}
