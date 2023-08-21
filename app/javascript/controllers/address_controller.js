import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="address"
export default class extends Controller {
  static targets = ['addAddressForm', 'buyAddressID', 'addressItem'];

  connect() {
  }

  toggleForm(e) {
    e.preventDefault();

    let el = this.addAddressFormTarget;
    let ariaExpanded = el.getAttribute('aria-expanded');

    el.classList.toggle('hide');
    el.classList.toggle('show');

    if(ariaExpanded == false) {
      el.setAttribute('aria-expanded', true)
    } else {
      el.setAttribute('aria-expanded', false)
    }
  }

  selectAddress(e) {
    let addressID = e.currentTarget.dataset.addr;

    if(!addressID) {
      console.log('invalid id')
      return
    }

    this.addressItemTargets.forEach(address => {
      address.classList.remove('selected')
    });

    e.currentTarget.classList.toggle('selected')
    this.buyAddressIDTarget.value = addressID;
  }
}
