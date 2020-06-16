import { Controller } from "stimulus";

export default class extends Controller {

  static targets = [ 'count' ];

  addQuantity(event) {
    const lineItemId = this.countTarget.dataset.lineItem;

    fetch(`/line_items/${lineItemId}/add_quantity`, {
      headers: { accept: "application/json" },
      method: 'POST'
    }).then(response => response.json())
      .then((data) => this.updateCartInfo(data))

    let currentQuantity = parseInt(this.countTarget.innerHTML)
    currentQuantity += 1
    this.countTarget.innerHTML = currentQuantity

  }

  reduce_quantity(event) {
    let currentQuantity = parseInt(this.countTarget.innerHTML)
    currentQuantity -= 1
    this.countTarget.innerHTML = currentQuantity
  }

  updateCartInfo(cartInfo) {
    const subTotal = document.querySelector('.sub_total');
    const totalItems = document.querySelector('.total_items');
    subTotal.innerHTML = cartInfo.sub_total
    totalItems.innerHTML = `${cartInfo.total_items} productos`;
  }
}

