import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="cart-count"
export default class extends Controller {
    static targets = ["itemCount"]

    connect() {
        console.log(this.itemCountTarget);
    }

    update({ detail: { totalItems } }) {
        this.itemCountTarget.innerText = `Cart ${totalItems}`;
    }
}
