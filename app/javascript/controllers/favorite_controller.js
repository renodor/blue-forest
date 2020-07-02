import { Controller } from "stimulus";

export default class extends Controller {

   static targets = [ 'toggle', 'icon', 'product' ];

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
        // when we have the response we need to do 3 things:
        // - remove the favorite-id from the toggle btn
        // - transform the toggle button so that it can now 'add' the product into user favorite list if clicked again
        // - change the icon
        this.toggleTarget.dataset.favoriteId = '';
        this.toggleTarget.dataset.action = 'click->favorite#addFavorite';
        this.iconTarget.classList.remove('liked');
      })
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
      // first we need to check if the user is authorized to add product to its favorites (if it is signed in)
      // if not the response will throw an error, in that case we redirect him to the sign in page

      // if the response doesn't throw an error, we need to do 3 things:
      // - add the favorite-id to the toggle btn
      // - transform the toggle button so that it can now 'remove' the product from user favorite list if clicked again
      // - change the icon
      .then(data => {
        if (data.error) {
          window.location.href = '/users/sign_in';
        } else {
          this.toggleTarget.dataset.favoriteId = data.product_favorite_id;
          this.toggleTarget.dataset.action = 'click->favorite#removeFavorite';
          this.iconTarget.classList.add('liked');
        }
      })
  }

  // specific action when favorites are removed from the dashboard
  removeFavoriteFromDashboard(event) {
    const productFavoritId = event.currentTarget.dataset.favoriteId

    fetch(`/product_favorites/${productFavoritId}`, {
      headers: {
        accept: "application/json",
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token'").getAttribute('content')
      },
      method: 'DELETE'
    }).then(response => {
        // when we have the response we need to do 2 things:
        // - remove the product favorite from the dashboard
        // - check if there are still some product favorite in the dashboard, if not reload the page to show the specific empty layout
        this.productTarget.remove();
        if (this.productTargets.length === 0) {
          location.reload();
        }
      })
  }

}

