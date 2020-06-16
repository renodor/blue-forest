import { Controller } from "stimulus";

export default class extends Controller {

  static targets = [ 'count' ];

  // when quantityTrigger btn is clicked, check if it was the 'add' or the 'remove' btn
  // and call the 'changeQuantity' method with the correct operator
  quantityTrigger(event) {
    const btnType = event.target.innerHTML;
    btnType === '+' ? this.changeQuantity('add') : this.changeQuantity('reduce')
  }

  // method that will trigger the 'add_quantity' or 'remove_quantity' actions of the line_items controller
  changeQuantity(operator) {
    const lineItemId = this.countTarget.dataset.lineItem;
    fetch(`/line_items/${lineItemId}/${operator}_quantity`, {
      headers: { accept: "application/json" },
      method: 'POST'
    }).then(response => response.json())
    // once the line_items controller action has been triggered, analyse the JSON response
    // if the response says we can change quantity we need to do 3 actions:
    // - change the quantity counter
    // - update cart info
    // - change the quantity counter in the navbar cart icon
    // if not show a js flash error message
      .then((data) => {
        if (data.can_change_quantity) {
          this.changeQuantityCounter(`${operator}`, lineItemId)
          this.updateCartInfo(data);
          this.changeCartToggleIcon(operator)
        } else {
          this.showJsFlash(data.error);
        }
      })
  }

  // method that update the quantity counter of the correct line items in the cart and sidebar cart
  changeQuantityCounter(operator, lineItem) {
    const counters = document.querySelectorAll('.quantity-counter');
    counters.forEach((counter) => {
      const counterCount = counter.querySelector('span')
      // iterate over all counters and find the ones that correspond to the correct line item
      if (counterCount.dataset.lineItem === lineItem) {
        const counterReduceBtn = counter.querySelector('button')
        let currentQuantity = parseInt(counterCount.innerHTML)
        // if we need to add quantity, add quantity
        // and enable the 'reduce' quantity btn
        if (operator === 'add') {
          currentQuantity += 1
          counterReduceBtn.disabled = false;
        // if we need to remove quantity, remove quantity
        // and disable the 'reduce quantity' btn if quantity is 1
        } else {
          currentQuantity -= 1
          if (currentQuantity === 1) { counterReduceBtn.disabled = true; }
        }
        counterCount.innerHTML = currentQuantity
      }
    })
  }

  // method that update cart and sidebar cart info
  updateCartInfo(cartInfo) {
    // get all cart elements
    const cart = document.getElementById('cart');
    const subTotals = document.querySelectorAll('.sub_total');
    const totalItems = document.querySelectorAll('.total_items');
    const itbms = document.querySelector('.itbms');
    const total = document.querySelector('.total');
    const shipping = document.querySelector('.shipping');


    // update the total items (in the cart and sidebar cart), making sure to pluralize it if needed
    totalItems.forEach((totalItem) => {
      if (cartInfo.total_items > 1) {
        totalItem.innerHTML = `${cartInfo.total_items} productos`
      } else {
        totalItem.innerHTML = `${cartInfo.total_items} producto`
      }
    });

    // update the subtotals (in the cart and sidebar cart)
    subTotals.forEach((subTotal) => subTotal.innerHTML = cartInfo.sub_total);

    if (cart) {
      // update itbms and total (not present in the sidebar cart)
      itbms.innerHTML = cartInfo.itbms
      total.innerHTML = cartInfo.total

      // update the shipping, making sure to show a custom message if shipping is free
      // (not present in the sidebar cart)
      cartInfo.shipping > 0 ? shipping.innerHTML = `$${cartInfo.shipping}` : shipping.innerHTML = "<b>¡Envío gratuito!</b>"
    }
  }

  // increase/decrease cart icon counter (in the navbar)
  changeCartToggleIcon(operator) {
    const cartIcon = document.querySelector('.cart-icon span');
    let cartIconCurrentQuantity = parseInt(cartIcon.innerHTML);
    console.log(cartIconCurrentQuantity);
    operator === 'add' ? cartIconCurrentQuantity += 1 : cartIconCurrentQuantity -= 1;
    cartIcon.innerHTML = cartIconCurrentQuantity;
  }

  // method that display the js flash messages
  showJsFlash(message) {
    const jsFlash = document.querySelector('.js-flash')
    const jsFlashMessage = document.querySelector('.js-flash-message')

    jsFlashMessage.innerHTML = message;
    jsFlash.classList.remove('display-none');
  }
}

