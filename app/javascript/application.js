// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import FingerprintJS from '@fingerprintjs/fingerprintjs';

import "controllers";

import { $, $hide, $show, $toggle, $toggleClass } from "./el";


const loadedEvent = 'DOMContentLoaded';


function toggleNavigation(e) {
    e.preventDefault();

    console.log("clicked");
    let primaryNav = $("#primary-nav");
    let toggleEl = $(".nav-toggle");
    let isExpanded = toggleEl.getAttribute('aria-expanded');

    let menuEl = $("#menu", toggleEl);
    let closeEl = $("#close", toggleEl);

    menuEl.classList.toggle("show");
    closeEl.classList.toggle("show");

    if(isExpanded === "false") {
        primaryNav.dataset.state = "open";
        toggleEl.setAttribute("aria-expanded", "true");
    } else {
        primaryNav.dataset.state = "close";
        toggleEl.setAttribute("aria-expanded", "false");
    }
}

// function pepperSpray() {
//     if(FingerprintJS) {
//         FingerprintJS
//             .load()
//             .then(fp => fp.get())
//             .then(result => {
//                 let el = document.querySelector("#pf");
//                 if (el && el.dataset) {
//                     el.dataset.pepper = result.visitorId;    
//                 }
//                 sessionStorage.setItem("cart_id", result.visitorId);

//                 document.removeEventListener(loadedEvent, pepperSpray);
//             });
//     } else {
//         console.error("fuck me dead!!");
//     }
// }
// document.addEventListener(loadedEvent, pepperSpray);

document.addEventListener(loadedEvent, () => {
    let toggleEl = $(".nav-toggle");

    toggleEl.addEventListener('click', toggleNavigation);
});
