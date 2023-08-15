import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
    static targets = ['toaster'];

    connect() {
        this.displayToast();
    }

    displayToast() {
        if (this.hasToasterTarget) {
            setTimeout(() => {
                 this.closeToast();
            }, 3000); 
        }
    }

    closeToast() {
        if (this.hasToasterTarget) {
            this.toasterTarget.classList.add('toast_close');
        }
    }
}
