import { Controller } from "stimulus";

export default class extends Controller {

   static targets = [ 'toggle', 'icon' ];

  // when removeFavorite toggle btn is clicked
  // remove the product from user favorite list
  removeFavorite(event) {
    const productFavoritId = event.currentTarget.dataset.favoriteId

    fetch(`/product_favorites/${productFavoritId}`, {
      headers: {
        accept: "application/json",
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token'").getAttribute('content')
      },
      method: 'DELETE'
    }).then(response => {
      // then we need to remove the favorite-id from the toggle btn
      // we need to transform the toggle button so that it can now 'add' the product into user favorite list if clicked again
      // and we need to change the icon
      this.toggleTarget.dataset.favoriteId = '';
      this.toggleTarget.dataset.action = 'click->favorite#addFavorite';
      this.iconTarget.classList.remove('liked');
    });
  }

  // when addFavorite toggle btn is clicked
  // add the product to user favorite list
  addFavorite(event) {
    const productId = event.currentTarget.dataset.productId;
    fetch(`/product_favorites`, {
      headers: {
        accept: 'application/json',
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token'").getAttribute('content')
      },
      method: 'POST',
      body: JSON.stringify({ product_id: productId})
    }).then(response => response.json())
      // then we need to add the favorite-id to the toggle btn
      // we need to transform the toggle button so that it can now 'remove' the product from user favorite list if clicked again
      // and we need to change the icon
      .then(data => {
        this.toggleTarget.dataset.favoriteId = data.product_favorite_id;
        this.toggleTarget.dataset.action = 'click->favorite#removeFavorite';
        this.iconTarget.classList.add('liked');
    })
  }
}

