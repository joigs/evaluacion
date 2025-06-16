import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [
        "field",
        "hiddenMonth",
        "unlockButton",
        "lockButton"
    ]

    syncMonth(event) {
        if (this.hasHiddenMonthTarget) {
            this.hiddenMonthTarget.value = event.target.value
        }
    }

    unlock() {
        this.fieldTargets.forEach(el => {
            if (el.tagName === "SELECT") {
                el.disabled = false
            } else {
                el.readOnly = false
            }
            el.classList.remove("bg-gray-800", "opacity-70", "cursor-not-allowed")
            el.classList.add("bg-gray-700", "cursor-text")
        })

        this.toggleButtons()
    }

    lock() {
        this.fieldTargets.forEach(el => {
            if (el.tagName === "SELECT") {
                el.disabled = true
            } else {
                el.readOnly = true
            }
            el.classList.remove("bg-gray-700", "cursor-text")
            el.classList.add("bg-gray-800", "opacity-70", "cursor-not-allowed")
        })

        this.toggleButtons()
    }

    toggleButtons() {
        this.unlockButtonTarget.classList.toggle("hidden")
        this.lockButtonTarget.classList.toggle("hidden")
    }
}
