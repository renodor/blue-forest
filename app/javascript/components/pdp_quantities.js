const pdpQuantities = () => {
  const pdpQuantitySelector = document.querySelector('.pdp-quantity-selector');

  if (pdpQuantitySelector) {
    const removeQuantity = pdpQuantitySelector.querySelector('button:first-child');
    const addQuantity = pdpQuantitySelector.querySelector('button:last-child');
    const quantity = pdpQuantitySelector.querySelector('input');

    addQuantity.addEventListener('click', (event) => {
      event.preventDefault();
      let currentQuantity = parseInt(quantity.value);
      if (currentQuantity < 10) {
        removeQuantity.disabled = false;
        event.currentTarget.disabled = false;
        currentQuantity += 1;
        quantity.value = currentQuantity;
      }
      if (currentQuantity === 10) {
        event.currentTarget.disabled = true;
      };
    });

    removeQuantity.addEventListener('click', (event) => {
      event.preventDefault();
      let currentQuantity = parseInt(quantity.value);
      if (currentQuantity > 1) {
        addQuantity.disabled = false;
        event.currentTarget.disabled = false;
        currentQuantity -= 1;
        quantity.value = currentQuantity;
      }
      if (currentQuantity === 1) {
        event.currentTarget.disabled = true;
      }
    });
  }
};

export {pdpQuantities};
