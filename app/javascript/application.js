// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import FingerprintJS from '@fingerprintjs/fingerprintjs';

import "controllers";

// import { $, $hide, $show, $toggle, $toggleClass } from "./el";
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

