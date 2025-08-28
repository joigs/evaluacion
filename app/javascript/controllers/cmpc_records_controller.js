import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"

export default class extends Controller {
    static targets = ["checkbox", "deleteBtn", "selectBtn", "form"]

    connect () {
        this.selectionEnabled = false
        this._setDeleteBtnVisible(false)   // oculto al iniciar
    }

    selectMode () {
        this.selectionEnabled = !this.selectionEnabled

        // Mostrar/ocultar checkboxes
        this.checkboxTargets.forEach(cb => {
            cb.classList.toggle("hidden", !this.selectionEnabled)
            if (!this.selectionEnabled) cb.checked = false
        })

        // Mostrar el botón cuando entro a selección; ocultarlo al salir
        this._setDeleteBtnVisible(this.selectionEnabled)
        // Al entrar, parte deshabilitado hasta que marquen algo
        this._setDeleteBtnEnabled(this._anyChecked())

        // Texto del botón principal
        this.selectBtnTarget.textContent = this.selectionEnabled ? "Cancelar" : "Seleccionar"
    }

    toggleSelection () {
        if (!this.selectionEnabled) return
        this._setDeleteBtnEnabled(this._anyChecked())
    }

    confirmDelete (event) {
        event.preventDefault()
        if (!this.selectionEnabled || !this._anyChecked()) return

        const seleccionados = this.checkboxTargets.filter(cb => cb.checked)
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
            customClass: { confirmButton: 'mr-10' }
        }).then(result => {
            if (!result.isConfirmed) return

            Swal.fire({
                icon: "question",
                title: "Confirmar eliminación",
                text: "Los registros deberían eliminarse únicamente si fueron un error.",
                showCancelButton: true,
                confirmButtonText: "Eliminar",
                cancelButtonText: "Volver",
                customClass: { confirmButton: 'mr-10' }
            }).then(r2 => {
                if (r2.isConfirmed) this.formTarget.requestSubmit()
            })
        })
    }

    // Turbo: éxito / error para los toasts
    afterDelete (e) {
        if (e.detail.success) {
            Swal.fire({ icon: "success", title: "Registros eliminados", timer: 1600, showConfirmButton: false })
        } else {
            Swal.fire({ icon: "error", title: "No se pudieron eliminar", text: "Inténtalo nuevamente." })
        }
    }

    // ——— helpers ———
    _anyChecked () {
        return this.checkboxTargets.some(cb => cb.checked)
    }

    _setDeleteBtnEnabled (enabled) {
        const btn = this.deleteBtnTarget
        if (enabled) {
            btn.removeAttribute("disabled")
            btn.classList.remove("opacity-50", "cursor-not-allowed")
        } else {
            btn.setAttribute("disabled", "disabled")
            btn.classList.add("opacity-50", "cursor-not-allowed")
        }
    }

    _setDeleteBtnVisible (visible) {
        this.deleteBtnTarget.classList.toggle("hidden", !visible)
        if (visible) this._setDeleteBtnEnabled(this._anyChecked())
    }
}
