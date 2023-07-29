import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="cart-add"
export default class extends Controller {
    static targets = [
        "selectSize",
        "productItem",
        "addToCartIcon",
        "sizeError"
    ];

    connect() {
        console.log(this.selectSizeTarget);
        console.log(this.productItemTarget);
    }

    addToCart(e) {
        e.preventDefault();

        let size = this.selectSizeTarget.value;
        let itemID = this.productItemTarget.dataset.itemId;

        if(!size) {
            this.showError("Please select size");
            console.error("invalid size");
            return;
        }

        if(!itemID) {
            console.error("something went wrong");
            return;
        }
        let pepper = sessionStorage && sessionStorage.getItem("pepper");
        if(!pepper) {
            let el = document.querySelector("#pf");
            if(el && el.dataset) {
                pepper = el.dataset.pepper;
            }
        }

        let cartItem = { size, itemID };

        try {
            let data = localStorage.getItem(pepper) || '[]';
            let itemsInCart = JSON.parse(data);

            data = JSON.stringify(itemsInCart.concat(cartItem));

            localStorage.setItem(pepper, data);

            if(!this.addToCartIconTarget.classList.contains('fill_animation')){
                this.addToCartIconTarget.classList.add('fill_animation');
            } 
            // we will change this such that instead of
            // cart-add, we can have generic handler.
            // or like each kind will have type of event
            // defined types. one for notification
            // TODO: handle notifications
            this.dispatch(
                'updated',
                { detail: { totalItems: itemsInCart.length + 1 } }
            );

            // dispatch event
        } catch(e) {
            console.error(e);
        }
    }

    showError(message) {
        const errTgt = this.sizeErrorTarget;

        errTgt.value = message;

        let classList = Array.from(errTgt.classList).reduce((acc, className) => {
            acc[className] = className;
            return acc;
        }, {});

        if (classList['vanish'] && !classList['appear']) {
            errTgt.innerHTML = message;
            classList = { ...classList, vanish: null, appear: 'appear'};

            errTgt.className = Object.keys(classList).join(' ');
        }

        setTimeout(function() {
            errTgt.classList.remove('appear');
            errTgt.innerHTML = '';
        }, 1200);
    }
}

