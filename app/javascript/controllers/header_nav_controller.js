import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="header-nav"
export default class extends Controller {
  static targets = [
    "slideMenu",
    "menuToggler",
    "hamOpen", "hamClose"
  ];

  connect() {
  }

  toggleSlideMenuCtrl(e) {
    e.preventDefault();

    let slideMenu = this.slideMenuTarget;
    console.log(slideMenu, "lk");

    let hamMenuState = slideMenu.dataset.state;
    let menuBtn = this.menuTogglerTarget;

    if(hamMenuState == "close") {
      this.hamOpenTarget.classList.remove("show")
      this.hamCloseTarget.classList.add("show")

      slideMenu.dataset.state = "open";
      menuBtn.setAttribute("aria-expanded", true)

      return
    }

    this.hamOpenTarget.classList.add("show");
    this.hamCloseTarget.classList.remove("show");

    slideMenu.dataset.state = "close";
    menuBtn.setAttribute("aria-expanded", false)
  }
}
