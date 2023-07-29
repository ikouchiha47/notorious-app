// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import FingerprintJS from '@fingerprintjs/fingerprintjs';

import "controllers";

import { $, $hide, $show, $toggle, $toggleClass } from "./el";


const loadedEvent = 'DOMContentLoaded';

function toggleMenu() {
    const $menuIcon = $("#menu-icon");
    const $menu = $("#header-nav-menu");
    const $closeIcon = $("#header-close-icon");

    // Hide the menu initially
    $hide($menu);

    // Toggle the menu on click of the menu icon
    $menuIcon.onclick = function() {
        $toggle($menu);
    };

    // Hide the menu on click of the close icon
    $closeIcon.onclick = function() {
        $hide($menu);
    };
}

function pepperSpray() {
    if(FingerprintJS) {
        FingerprintJS
            .load()
            .then(fp => fp.get())
            .then(result => {
                let el = document.querySelector("#pf");
                if (el && el.dataset) {
                    el.dataset.pepper = result.visitorId;    
                }
                sessionStorage.setItem("cart_id", result.visitorId);

                document.removeEventListener(loadedEvent, pepperSpray);
            });
    } else {
        console.error("fuck me dead!!");
    }
}

document.addEventListener(loadedEvent, pepperSpray);
document.addEventListener(loadedEvent, toggleMenu);
