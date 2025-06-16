import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"

export default class extends Controller {
    static targets = [
        "modal",
        "dayValue",
        "countDisplay",
        "countHidden",
        "hiddenDate"
    ]

    open (event) {
        const dateISO = event.currentTarget.dataset.date
        this.hiddenDateTarget.value = dateISO
        const [y, m, d] = dateISO.split("-")
        this.dayValueTarget.textContent = `${d}/${m}/${y}`

        this.setCount(1)
        this.modalTarget.classList.remove("hidden")
        document.body.classList.add("overflow-hidden")
    }

    close () {
        this.modalTarget.classList.add("hidden")
        document.body.classList.remove("overflow-hidden")
    }

    inc () { this.update(+1) }
    dec () { this.update(-1) }

    update (delta) {
        const current = parseInt(this.countDisplayTarget.value || "1", 10) || 1
        this.setCount(Math.max(1, current + delta))
    }

    setCount (v) {
        this.countDisplayTarget.value = v
        this.countHiddenTarget.value  = v
    }

    afterSubmit (event) {
        if (event.detail.success) {
            this.close()
            Swal.fire({
                icon:  "success",
                title: "Registros añadidos",
                text:  "Los conductores se agregaron correctamente."
            })
        }
    }
}
