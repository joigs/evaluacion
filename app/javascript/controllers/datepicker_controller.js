import { Controller } from "@hotwired/stimulus"

const ALT_CLASS = "fp-alt-input"

export default class extends Controller {
    static values = {
        minDate: { type: String, default: "2020-01-01" },
        maxDate: { type: String, default: "3000-12-31" }
    }

    connect() {
        this.onBeforeCache = () => this.teardown()
        this.onPageShow = (event) => { if (event.persisted) this.setup() }

        document.addEventListener("turbo:before-cache", this.onBeforeCache)
        window.addEventListener("pageshow", this.onPageShow)

        this.setup()
    }

    disconnect() {
        document.removeEventListener("turbo:before-cache", this.onBeforeCache)
        window.removeEventListener("pageshow", this.onPageShow)
        this.teardown()
    }

    setup() {
        if (typeof window.flatpickr !== "function") return
        if (this.element._flatpickr) return

        this.limpiarRestos()

        window.flatpickr(this.element, {
            locale: "es",
            dateFormat: "Y-m-d",
            altInput: true,
            altFormat: "d-m-Y",
            altInputClass: `${ALT_CLASS} ${this.element.className}`,
            minDate: this.minDateValue,
            maxDate: this.maxDateValue,
            static: false
        })
    }

    teardown() {
        if (this.element._flatpickr) this.element._flatpickr.destroy()
        this.limpiarRestos()
    }

    limpiarRestos() {
        const padre = this.element.parentNode
        if (!padre) return

        padre.querySelectorAll(`.${ALT_CLASS}`).forEach((el) => el.remove())
        if (this.element.type === "hidden") this.element.type = "text"
    }
}