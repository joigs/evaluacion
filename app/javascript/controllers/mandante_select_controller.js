import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["select", "nombre", "boton", "estado"]
    static values  = { refreshUrl: String }

    connect() {
        this.sync()
    }

    sync() {
        if (!this.hasSelectTarget || !this.hasNombreTarget) return

        const opcion = this.selectTarget.selectedOptions[0]
        this.nombreTarget.value = opcion && opcion.value ? opcion.text.trim() : ""
    }

    async refresh() {
        if (!this.hasRefreshUrlValue || !this.hasSelectTarget) return

        this.#ocupado(true)
        this.#estado("Actualizando…", false)

        try {
            const respuesta = await fetch(this.refreshUrlValue, {
                headers: { "Accept": "application/json" },
                credentials: "same-origin"
            })

            if (!respuesta.ok) throw new Error(`HTTP ${respuesta.status}`)

            const json = await respuesta.json()
            const lista = json.data || []

            this.#repoblar(lista)
            this.#estado(`Lista actualizada: ${lista.length} empresas.`, false)
        } catch (error) {
            this.#estado("No se pudo actualizar la lista.", true)
        } finally {
            this.#ocupado(false)
        }
    }

    #repoblar(mandantes) {
        const seleccionado = this.selectTarget.value
        const nombrePrevio = this.hasNombreTarget ? this.nombreTarget.value : ""
        const placeholder  = this.selectTarget.options[0]

        this.selectTarget.innerHTML = ""

        if (placeholder && !placeholder.value) {
            this.selectTarget.appendChild(placeholder)
        }

        mandantes.forEach((m) => {
            const opcion = document.createElement("option")
            opcion.value = m.rut
            opcion.text  = m.nombre
            this.selectTarget.appendChild(opcion)
        })

        if (seleccionado) {
            const sigueEnLista = mandantes.some((m) => String(m.rut) === String(seleccionado))

            if (!sigueEnLista) {
                const opcion = document.createElement("option")
                opcion.value = seleccionado
                opcion.text  = `${nombrePrevio} (fuera de la lista actual)`
                this.selectTarget.insertBefore(opcion, this.selectTarget.options[1] || null)
            }

            this.selectTarget.value = seleccionado
        }

        this.sync()
    }

    #ocupado(estado) {
        if (!this.hasBotonTarget) return

        this.botonTarget.disabled = estado
        this.botonTarget.classList.toggle("opacity-50", estado)
        this.botonTarget.classList.toggle("cursor-not-allowed", estado)
    }

    #estado(texto, esError) {
        if (!this.hasEstadoTarget) return

        this.estadoTarget.textContent = texto
        this.estadoTarget.classList.toggle("text-red-400", esError)
        this.estadoTarget.classList.toggle("text-gray-400", !esError)
    }
}