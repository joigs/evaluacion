import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"

export default class extends Controller {
    static targets = ["checkbox", "deleteBtn", "selectBtn", "form"]

    connect () { this.selectionEnabled = false }

    selectMode () {
        this.selectionEnabled = !this.selectionEnabled
        this.checkboxTargets.forEach(cb => {
            cb.classList.toggle("hidden", !this.selectionEnabled)
            cb.checked = false
        })
        this.deleteBtnTarget.classList.add("hidden")
        this.selectBtnTarget.textContent = this.selectionEnabled ? "Cancelar" : "Seleccionar"
    }

    toggleSelection () {
        if (!this.selectionEnabled) return
        const algoMarcado = this.checkboxTargets.some(cb => cb.checked)
        this.deleteBtnTarget.classList.toggle("hidden", !algoMarcado)
    }

    confirmDelete (event) {
        event.preventDefault()

        const seleccionados = this.checkboxTargets.filter(cb => cb.checked)
        if (seleccionados.length === 0) return

        const fechas = seleccionados.map(cb =>
            cb.closest("tr").querySelector("[data-date-cell]").textContent.trim()
        )

        const listaHTML = fechas.map(f => `<li>${f}</li>`).join("")

        Swal.fire({
            icon: "warning",
            title: "¿Eliminar registros?",
            html: `Se eliminarán los siguientes registros:<ul style="text-align:left">${listaHTML}</ul>`,
            showCancelButton: true,
            confirmButtonText: "Eliminar",
            cancelButtonText: "Cancelar",
            customClass: {
                confirmButton: 'mr-10'
            }
        }).then(result => {
            if (!result.isConfirmed) return

            Swal.fire({
                icon: "question",
                title: "Confirmar eliminación",
                text: "Los registros deberían eliminarse únicamente si fueron un error.",
                showCancelButton: true,
                confirmButtonText: "Eliminar",
                cancelButtonText: "Volver",
                customClass: {
                    confirmButton: 'mr-10'
                }
            }).then(r2 => {
                if (r2.isConfirmed) this.formTarget.requestSubmit()
            })
        })
    }
}
