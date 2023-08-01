import { Controller } from "@hotwired/stimulus"

import * as db from "helpers/storage";

// Connects to data-controller="cart-add"
export default class extends Controller {
    static targets = [
        "selectSize",
        "productItem",
        "addToCartIcon",
        "buyNowSize",
        "buyNowItemID",
    ];

    connect() {
        console.log(this.selectSizeTarget);
        console.log(this.productItemTarget);

        let itemID = this.productItemTarget.dataset.itemId;
        let isLoggedIn = this.productItemTarget.dataset.isLoggedIn;

        if(itemID && db.checkItemPresent(itemID) && isLoggedIn == 'true') {
            this.addToCartIconTarget.disabled = true;
        }
    }

    addToCart(e) {
        e.preventDefault();

        let size = this.selectSizeTarget.value;
        let itemID = this.productItemTarget.dataset.itemId;

        if(!size) {
            this.attentionSizeError();
            return;
        }

        if(!itemID) {
            console.error("something went wrong");
            return;
        }

        let result = db.addCartItem( { size, itemID });
        if(!result) {
            console.error("someshit went down");
            return;
        }

        this.buyNowSizeTarget.value = `${size}`;

        this.dispatch(
            'updated',
            { detail: { totalItems: result } }
        );


        // try {
        //     let data = localStorage.getItem(pepper) || '[]';
        //     let itemsInCart = JSON.parse(data);

        //     data = JSON.stringify(itemsInCart.concat(cartItem));

        //     localStorage.setItem(pepper, data);

        //     if(!this.addToCartIconTarget.classList.contains('fill_animation')){
        //         this.addToCartIconTarget.classList.add('fill_animation');
        //     } 
        //     // we will change this such that instead of
        //     // cart-add, we can have generic handler.
        //     // or like each kind will have type of event
        //     // defined types. one for notification
        //     // TODO: handle notifications
        //     this.dispatch(
        //         'updated',
        //         { detail: { totalItems: itemsInCart.length + 1 } }
        //     );

        //     // dispatch event
        // } catch(e) {
        //     console.error(e);
        // }
    }

    updateItem(e) {
        let itemID = this.productItemTarget.dataset.itemId;
        let size = this.selectSizeTarget.value;

        console.log(size);
    }

    directBuy(e) {

        let itemID = this.buyNowItemIDTarget.value;
        let size = this.selectSizeTarget.value;

        console.log(itemID, size);
        if(itemID && size) {
            this.buyNowSizeTarget.value = size;
        } else {
            e.preventDefault();
            this.attentionSizeError();
        }

    }

    attentionSizeError() {
        const dropDown = this.selectSizeTarget;

        if(dropDown.classList.contains('attention')) {
            return;
        }

        dropDown.classList.add('attention');
        setTimeout(() => {
            dropDown.classList.remove('attention');
        },  1000);
    }

}

