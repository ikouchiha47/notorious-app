// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import { $, $hide, $show, $toggle, $toggleClass } from "./el";


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

document.addEventListener('DOMContentLoaded', function() {
    toggleMenu();
})
