import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  copy() {
    navigator.clipboard.writeText(this.content)
    alert("API token copied to clipboard!")
  }

  get content() {
    return this.element.dataset.clipboardContent
  }

}
