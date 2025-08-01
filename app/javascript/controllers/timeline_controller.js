import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = { facturacionId: Number }

    setPasoActual(event) {
        const pasoIdx = event.currentTarget.dataset.idx

        fetch(`/evaluacion/cotizaciones/${this.facturacionIdValue}/update_paso_actual`, {
            method: 'PATCH',
            headers: {
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ paso_actual: pasoIdx })
        })

            .then(response => {
                if (!response.ok) throw new Error("Network response was not ok")
                return response.json()
            })
            .then(data => {
                if (data.success) {
                    window.location.reload()
                } else {
                    alert("Error al actualizar el paso")
                }
            })
            .catch(() => alert("No se pudo actualizar el paso"))
    }
}
