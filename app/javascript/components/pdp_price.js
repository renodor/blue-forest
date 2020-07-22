const pdpPrice = () => {
  const pdpContainer = document.querySelector('.pdp-container');
  if (pdpContainer) {
    const sizes = document.querySelectorAll('.pdp .sizes input');
    const colors = document.querySelectorAll('.pdp .colors input');
    const price = document.querySelector('.pdp .price');
    const discountPrice = document.querySelector('.pdp .discount-price');

    // helper method to update the price (and discount price) on the PDP
    // regarding what product variation (size variation) is selected
    const updatePrice = (productVariation) => {
      const newPrice = productVariation.dataset.price;
      price.innerHTML = `$${newPrice}`;
      if (productVariation.dataset.discountPrice) {
        const newDiscountPrice = productVariation.dataset.discountPrice;
        price.classList.add('crossed');
        discountPrice.innerHTML = `$${newDiscountPrice}`;
      } else {
        discountPrice.innerHTML = '';
        price.classList.remove('crossed');
      }
    };

    // update price regarding what product variation is selected
    sizes.forEach((size) => {
      size.addEventListener('click', (event) => {
        if (size.checked) {
          updatePrice(event.currentTarget);
        }
      });
    });

    // if there are color variations but unique sizes, sizes don't appear on front end, so they can't be clicked
    // in that case we need to check for clicks on the colors and show the price corresponding to the correct color
    if (sizes[0].dataset.unique) {
      colors.forEach((color) => {
        color.addEventListener('click', (event) => {
          const targetColor = event.currentTarget.value;
          const targetSize = document.querySelector(`.pdp .sizes input[data-color=${targetColor}`);
          updatePrice(targetSize);
        });
      });
    }
  };
};


export {pdpPrice};
