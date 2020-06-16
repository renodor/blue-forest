import { Controller } from "stimulus";

export default class extends Controller {

  static targets = [ 'count' ];

  addQuantity() {
    const lineItemId = this.countTarget.dataset.lineItem;
    fetch(`/line_items/${lineItemId}/add_quantity`, {
      headers: { accept: "application/json" },
      method: 'POST'
    }).then(response => response.json())
      .then((data) => {
        if (data.can_add_quantity) {
          this.changeQuantityCounter('+', lineItemId)
          this.updateCartInfo(data);
        } else {
          this.showJsFlash(data.error);
        }
      })
  }

  reduceQuantity() {
    const lineItemId = this.countTarget.dataset.lineItem;
    fetch(`/line_items/${lineItemId}/reduce_quantity`, {
      headers: { accept: "application/json" },
      method: 'POST'
    }).then(response => response.json())
      .then((data) => {
        if (data.can_remove_quantity) {
          this.changeQuantityCounter('-', lineItemId)
          this.updateCartInfo(data);
        } else {
          this.showJsFlash(data.error);
        }
      })
  }

  changeQuantityCounter(operator, lineItem) {
    const counters = document.querySelectorAll('.quantity-counter');
    counters.forEach((counter) => {
      const counterCount = counter.querySelector('span')
      if (counterCount.dataset.lineItem === lineItem) {
        const counterReduceBtn = counter.querySelector('button')
        let currentQuantity = parseInt(counterCount.innerHTML)
        if (operator === '+') {
          currentQuantity += 1
          counterReduceBtn.disabled = false;
        } else {
          currentQuantity -= 1
          if (currentQuantity === 1) { counterReduceBtn.disabled = true; }
        }
        counterCount.innerHTML = currentQuantity
      }
    })
  }

  updateCartInfo(cartInfo) {
    const subTotals = document.querySelectorAll('.sub_total');
    const totalItems = document.querySelectorAll('.total_items');
    const itbms = document.querySelector('.itbms');
    const total = document.querySelector('.total');
    const shipping = document.querySelector('.shipping');

    totalItems.forEach((totalItem) => totalItem.innerHTML = `${cartInfo.total_items} productos`);
    subTotals.forEach((subTotal) => subTotal.innerHTML = cartInfo.sub_total);
    itbms.innerHTML = cartInfo.itbms
    total.innerHTML = cartInfo.total
    cartInfo.shipping > 0 ? shipping.innerHTML = `$${cartInfo.shipping}` : shipping.innerHTML = "<b>¡Envío gratuito!</b>"
  }

  showJsFlash(message) {
    const jsFlash = document.querySelector('.js-flash')
    const jsFlashMessage = document.querySelector('.js-flash-message')

    jsFlashMessage.innerHTML = message;
    jsFlash.classList.remove('display-none');
  }
}

