const pdpPrice = () => {

  const sizes = document.querySelectorAll('.pdp .size input');
  const price = document.querySelector('.pdp .price');


    sizes.forEach(size => {
      size.addEventListener('click', event => {
        if (size.checked) {
          const new_price = event.currentTarget.dataset.price;
          price.innerHTML = `$${new_price}`;
        }
      })
    });
}


export { pdpPrice };
