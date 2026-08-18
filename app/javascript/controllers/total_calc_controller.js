import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["cantidad", "valor", "output"]

    connect() {
        this.calcular()
    }

    calcular() {
        if (!this.hasOutputTarget) return

        const n = this.#numero(this.hasCantidadTarget ? this.cantidadTarget.value : 0)
        const v = this.#numero(this.hasValorTarget ? this.valorTarget.value : 0)

        const total = Math.round(n * v * 100) / 100

        this.outputTarget.value = total.toLocaleString("es-CL", {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        })
    }

    #numero(bruto) {
        const n = parseFloat(String(bruto).replace(",", "."))
        return Number.isFinite(n) && n >= 0 ? n : 0
    }
}