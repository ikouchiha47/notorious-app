import { Controller } from "@hotwired/stimulus";

import * as db from "helpers/storage";

// Connects to data-controller="cart-count"
export default class extends Controller {
    static targets = ["itemCount"]

    connect() {
        console.log(this.itemCountTarget);
        let totalItems = db.countItems();

        if(totalItems > 0) {
            this.itemCountTarget.innerText = `Cart ${totalItems}`;
        }


    }

    update({ detail: { totalItems } }) {
        this.itemCountTarget.innerText = `Cart ${totalItems}`;
    }
}
