import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="cart-add"
export default class extends Controller {
    static targets = ["selectSize", "productItem"];

    connect() {
        console.log(this.selectSizeTarget);
        console.log(this.productItemTarget);
    }

    addToCart(e) {
        e.preventDefault();

        let size = this.selectSizeTarget.value;
        let itemID = this.productItemTarget.dataset.itemId;

        let tempCartID = null;

        if(!window.sessionStorage) {
            return;
        }

        let cartToken = window.sessionStorage.getItem("cartToken");

        // For create it will be /carts. for update it will be /carts/:id
        // So we just only need the first part

        let submitURL = this.productItemTarget.dataset.cartUrl;
        let method = "post";

        console.log('cartToken', cartToken);

        if(!!cartToken) {
            submitURL = `${submitURL}/${cartToken}`;
            method = "patch";
        }


        let formData = new FormData();
        formData.append("cart[size]", size);
        formData.append("cart[item_id]", itemID);

        if(!!cartToken) {
            formData.append("cart[token]", cartToken);
        }
        const csrfToken = document
              .querySelector("meta[name='csrf-token']")
              .getAttribute('content');

        const headers = new Headers();
        headers.append('X-CSRF-Token', csrfToken);

        let that = this;



        fetch(submitURL, {
            method: method,
            headers: headers,
            body: formData,
        })
            .then(resp => resp.json())
            .then(data => {
                if(!data.cart_token || data.cart_token === false) {
                    console.error("something went wrong");
                    return;
                }

                sessionStorage.setItem('cartToken', data.cart_token);
                sessionStorage.setItem('cartItems', data.total_items);

                that.dispatch(
                    'updated',
                    { detail: { totalItems: data.total_items } }
                );
            })
            .catch(err => {
                console.error(err);
            });
    }

}

