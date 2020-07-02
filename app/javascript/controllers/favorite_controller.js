import { Controller } from "stimulus";

export default class extends Controller {

   static targets = [ 'add', 'icon' ];

  // when removeProduct btn is clicked
  // remove the targeted product from cart and sidebar cart
  removeFavorite(event) {
    const productFavoritId = event.currentTarget.dataset.favoriteId
    // triger the 'destroy' action of the product_favorites controller on the correct product_favorite
    fetch(`/product_favorites/${productFavoritId}`, {
      headers: {
        accept: "application/json",
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token'").getAttribute('content')
      },
      method: 'DELETE'
    }).then(response => {
      this.addTarget.dataset.action = 'click->favorite#addFavorite';
      this.iconTarget.classList.remove('liked');
    });
  }

  addFavorite(event) {
    const productId = event.currentTarget.dataset.productId;
    // triger the 'destroy' action of the product_favorites controller on the correct product_favorite
    fetch(`/product_favorites`, {
      headers: {
        accept: 'application/json',
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token'").getAttribute('content')
      },
      method: 'POST',
      body: JSON.stringify({ product_id: productId})
    }).then(response => response.json())
      .then(data => {
        this.addTarget.dataset.favoritId = data.product_favorite_id;
        this.addTarget.dataset.action = 'click->favorite#removeFavorite';
        this.iconTarget.classList.add('liked');
    })
  }
}

