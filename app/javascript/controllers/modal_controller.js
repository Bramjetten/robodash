import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
  }

  close() {
    // Removes itself from the DOM
    this.element.remove()
  }

}
