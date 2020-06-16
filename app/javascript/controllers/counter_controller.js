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
    const subTotals = document.querySelectorAll('.sub_total');
    const totalItems = document.querySelectorAll('.total_items');
    const itbms = document.querySelector('.itbms');
    const total = document.querySelector('.total');

    totalItems.forEach((totalItem) => totalItem.innerHTML = `${cartInfo.total_items} productos`);
    subTotals.forEach((subTotal) => subTotal.innerHTML = cartInfo.sub_total);
    itbms.innerHTML = cartInfo.itbms
    total.innerHTML = cartInfo.total

  }
}

