// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")



// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)


// ----------------------------------------------------
// Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
// WRITE YOUR OWN JS STARTING FROM HERE 👇
// ----------------------------------------------------

// External imports
import "bootstrap";

// Internal imports
import { initMapbox } from '../plugins/init_mapbox';

import { hideJsFlash } from '../components/hide_js_flash';
import { sidebarCart } from '../components/sidebar_cart';
import { pdpVariations } from '../components/pdp_variations';
import { pdpPrice } from '../components/pdp_price';
import { pdpPhotos } from '../components/pdp_photos';
import { atcModal } from '../components/atc_modal';
import { doctorsCarousel } from '../components/doctors_carousel';
import { boostrapTabs } from '../components/boostrap_tabs';
import { productCreation } from '../components/product_creation';


document.addEventListener('turbolinks:load', () => {
  // Call your functions here
  hideJsFlash();
  sidebarCart();
  pdpVariations();
  pdpPrice();
  pdpPhotos();
  initMapbox();
  atcModal();
  doctorsCarousel();
  boostrapTabs();
  productCreation();
});


// importe stimulus controllers
import "controllers"
