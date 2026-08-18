import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = {
        url: String,
        titulo: { type: String, default: "¿Eliminar este registro?" },
        texto: { type: String, default: "Esta acción no se puede deshacer." }
    }

    async confirmar(event) {
        event.preventDefault()

        if (!this.hasUrlValue) return
        if (typeof Swal === "undefined") return

        const resultado = await Swal.fire({
            icon: "warning",
            title: this.tituloValue,
            text: this.textoValue,
            showCancelButton: true,
            reverseButtons: true,
            focusCancel: true,
            confirmButtonText: "Sí, eliminar",
            cancelButtonText: "Cancelar",
            confirmButtonColor: "#dc2626",
            cancelButtonColor: "#4b5563"
        })

        if (!resultado.isConfirmed) return

        this.#enviar()
    }

    #enviar() {
        const form = document.createElement("form")
        form.method = "post"
        form.action = this.urlValue
        form.style.display = "none"
        form.setAttribute("data-turbo", "false")

        const metodo = document.createElement("input")
        metodo.type = "hidden"
        metodo.name = "_method"
        metodo.value = "delete"
        form.appendChild(metodo)

        const token = document.querySelector("meta[name='csrf-token']")
        if (token) {
            const csrf = document.createElement("input")
            csrf.type = "hidden"
            csrf.name = "authenticity_token"
            csrf.value = token.content
            form.appendChild(csrf)
        }

        document.body.appendChild(form)
        form.submit()
    }
}