import { Controller } from "stimulus";

export default class extends Controller {

  static targets = [ 'count' ];

  // connect() {
  //   console.log(this.countTarget);
  // }

  add_quantity(event) {
    let currentQuantity = parseInt(this.countTarget.innerHTML)
    currentQuantity += 1
    this.countTarget.innerHTML = currentQuantity
  }

  reduce_quantity(event) {
    let currentQuantity = parseInt(this.countTarget.innerHTML)
    currentQuantity -= 1
    this.countTarget.innerHTML = currentQuantity
  }
}
