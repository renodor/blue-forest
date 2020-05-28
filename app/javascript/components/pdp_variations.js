const pdpVariations = () => {
  const pdpContainer = document.querySelector('.pdp-container');
  if (pdpContainer) {
    // select sizes and colors inputs
    const sizes = document.querySelectorAll('.pdp .sizes input');
    const colors = document.querySelectorAll('.pdp .colors input');

    // helper method to disable sizes that don't belong to the selected color
    // and to display-none sizes that are repeated accross colors
    const disableSizes = (size, targetColor) => {
      // if size belong to current selected color we do 2 things:
      // 1. enable size
      // 2. check if size is repeated. If yes, it means it was hidden when color was not selected (to avoid repeted sizes on front end). So we need to display it again
      if (size.dataset.color == targetColor) {
        size.disabled = false;
      // id size doesn't belong to current selected color, we do 3 things
      // 1. uncheck size (to make sure no size remain checked if user change color seleccion)
      // 2. disable size
      // 3. check if size is repeated, if yes hide it
      } else {
        size.checked = false;
        size.disabled = true;
      }
    }

    // making sure that there is more than 1 color. Otherwise the color option is not even displayed
    if (colors.length > 1) {
      // when page load, first color is automatically selected
      // so we need to call our 'disableSizes' method on the first colour
      sizes.forEach((size) => {
        const targetColor = colors[0].dataset.color;
        disableSizes(size, targetColor);
      })
    }

    // add event listener on color selection
    // each time user select a different color, if sizes is note 'unique', we need to call our 'disableSize' method on this color
    colors.forEach((color) => {
      color.addEventListener('click', event => {
        sizes.forEach((size) => {
          const targetColor = color.dataset.color;
          // if size is unique, there is no size choice to make. So just enable and check the size of the target color
          // and disable and uncheck sizes of the not targeted color
          if (size.dataset.unique) {
            if (size.dataset.color === color.dataset.color) {
              size.disabled = false
              size.checked = true
            } else {
              size.disabled = true
              size.checked = false
            }
          } else {
            disableSizes(size, targetColor);
          }
        });
      });
    });

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
  };
}

export { pdpVariations };
