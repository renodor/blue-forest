const sizeCheckbox = () => {
  const sizes = document.querySelectorAll('.pdp .size input');
  if (sizes.length > 0) {
    const atc = document.querySelector('.pdp .atc');
    const atcOverlay = document.querySelector('.pdp .atc-overlay');
    const sizeWarning = document.querySelector('.size-selection-warning');

    // disable add to cart button by default
    atc.disabled = true

    // check if one size is selected (after making sure the page is fully loaded)
    // if yes, disable the overlay and enable the add to cart button
    // this step is needed if you hit the 'previous' button of your browser
    setTimeout(() => {
      sizes.forEach(size => {
        if(size.checked) {
          atcOverlay.style.display = 'none';
          atc.disabled = false
        }
      })
    }, 1);

    // When a size is checked, disable the overlay, disable warning message, and enable the add to cart button
    sizes.forEach(size => {
      size.addEventListener('click', event => {
        if (size.checked) {
          atcOverlay.style.display = 'none';
          sizeWarning.style.display = 'none';
          atc.disabled = false;
        }
      })
    });

    // if add to cart is disabled and there is a click on it show a warning message
    // (we need to have a add to cart overlay for that because disabled button don't trigger events)
    atcOverlay.addEventListener('click', event => {
      if (atc.disabled) {
        sizeWarning.style.display = 'block';
      }
    })

  }
}

export { sizeCheckbox };
