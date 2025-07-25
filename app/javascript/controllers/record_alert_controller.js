import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"

export default class extends Controller {
    static values = { title: String, message: String, newUrl: String }

    connect () {
        Swal.fire({
            icon:  "info",
            title: this.titleValue || "Aviso",
            html:  this.messageValue,
            showCancelButton: true,
            confirmButtonText: "Crear ahora",
            cancelButtonText: "Ocultar",
            customClass: { confirmButton: 'mr-10' },
            focusCancel: true
        }).then(result => {
            if (result.isConfirmed) window.location.href = this.newUrlValue
        })
    }
}
