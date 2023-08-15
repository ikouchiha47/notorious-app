import { Controller } from "@hotwired/stimulus";

import * as db from "helpers/storage";

// Connects to data-controller="cart-count"
export default class extends Controller {
    static targets = ["itemCount"]

    connect() {
        let totalItems = db.countItems();

        if(totalItems > 0) {
            this.itemCountTarget.innerText = `${totalItems} Cart `;
        }
    }

    update({ detail: { totalItems } }) {
        this.itemCountTarget.innerText = `${totalItems} Cart`;
    }
}
