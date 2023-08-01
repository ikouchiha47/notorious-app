import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
    static targets = ['toaster', 'expiryMeter'];

    connect() {
        this.displayToast();
    }

    displayToast() {
        if (this.hasToasterTarget) {
            this.expiryMeterTarget.classList.add('expiry_close');

            setTimeout(() => {
                 this.closeToast();
            }, 3000); 
        }
    }

    closeToast() {
        if (this.hasToasterTarget) {
            let expT = this.expiryMeterTarget;

            if (!expT.classList.contains('expiry_close')) {
                    expT.classList.add('expiry-close');
            }
            this.toasterTarget.classList.add('toast_close');
        }
    }
}
