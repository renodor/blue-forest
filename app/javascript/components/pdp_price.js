const pdpPrice = () => {

  const pdpContainer = document.querySelector('.pdp-container');
  if (pdpContainer) {
    const sizes = document.querySelectorAll('.pdp .sizes input');
    const price = document.querySelector('.pdp .price');
    const discountPrice = document.querySelector('.pdp .discount-price');

    // update price regarding what product variation is selected
    sizes.forEach(size => {
      size.addEventListener('click', event => {
        if (size.checked) {
          const newPrice = event.currentTarget.dataset.price;
          price.innerHTML = `$${newPrice}`;
          if (event.currentTarget.dataset.discountPrice) {
            const newDiscountPrice = event.currentTarget.dataset.discountPrice;
            price.classList.add('crossed');
            discountPrice.innerHTML = `$${newDiscountPrice}`;
          } else {
            discountPrice.innerHTML = "";
            price.classList.remove('crossed');
          }
        }
      })
    });
  };
}


export { pdpPrice };
