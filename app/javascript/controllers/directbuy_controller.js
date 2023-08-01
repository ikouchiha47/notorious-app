import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="directbuy"
export default class extends Controller {
    static targets = [
        "buyNowSize",
        "buyNowItemID",
    ];

    connect() {
    }

    execute(e) {
        console.log("buynosize ", this.buyNowSizeTarget.value)
        console.log("itemID", )
        if (!(this.buyNowSizeTarget.value && this.buyNowItemIDTarget.value)) {
            e.preventDefault();
            this.attentionSizeError();

            return;
        }
    }
}
