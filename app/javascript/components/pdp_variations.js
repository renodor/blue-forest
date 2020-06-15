const pdpVariations = () => {
  const pdpContainer = document.querySelector('.pdp-container');
  if (pdpContainer) {
    // select sizes and colors inputs
    const sizes = document.querySelectorAll('.pdp .sizes input');
    const colors = document.querySelectorAll('.pdp .colors input');

    const atc = document.querySelector('.pdp .atc');
    const atcOverlay = document.querySelector('.pdp .atc-overlay');
    const sizeWarning = document.querySelector('.size-selection-warning');


    console.log(sizes);

    // helper method to disable sizes that don't belong to the selected color
    // and to display-none sizes that are repeated accross colors
    const disableSizes = (size, targetColor, first) => {

      atc.disabled = true;
      atcOverlay.style.display = 'block';

      // if size belong to current selected color we do 2 things:
      // 1. enable size
      // 2. make sure that size label is displayed (it could have been hiden before if this size is repeated)
      if (size.dataset.color == targetColor) {
        size.disabled = false;
        document.querySelector(`label[for=variation_id_${size.value}]`).style.display = 'inline-block'

      // if size doesn't belong to current selected color, we do 3 things
      // 1. uncheck size (to make sure no size remain checked if user change color seleccion)
      // 2. disable size
      // 3. check if size is repeated for the current target color, if yes hide its label (to avoid repeated sizes on front end)
      } else {
        size.checked = false;
        size.disabled = true;
        if (size.dataset.repeatedFor.match(targetColor)) {
          document.querySelector(`label[for=variation_id_${size.value}]`).style.display = 'none';
        }
      }
    }

    // simple healper method for 'unique' sizes
    // if size is unique, and there are several colors, we just need to enable and check the size of the target color
    // and disable and uncheck the other sizes
    const uniqueSizesToggle = (size, targetColor) => {
     if (size.dataset.color === targetColor) {
        size.disabled = false
        size.checked = true
      } else {
        size.disabled = true
        size.checked = false
      }
    }

    // making sure that there is more than 1 color. Otherwise the color option is not even displayed
    if (colors.length > 1) {
      // when page load, select the checked color (the one of the main photo)
      // and call our 'disableSizes' method on this color
      const targetColor = document.querySelector('.pdp .colors input:checked').value;
      sizes.forEach((size) => {
        // if size is 'unique', call a different method that will just check the size for the target color and uncheck the others
        if (size.dataset.unique) {
          uniqueSizesToggle(size, targetColor);
        } else {
          disableSizes(size, targetColor);
        }
      })
    }

    // add event listener on color selection
    // each time user select a different color, we need to call our 'disableSizes' method on the selected color
    colors.forEach((color) => {
      color.addEventListener('click', event => {
        sizes.forEach((size, i) => {
          const targetColor = color.value;
          // if size is 'unique', call a different method that will just check the size for the target color and uncheck the others
          if (size.dataset.unique) {
            uniqueSizesToggle(size, targetColor);
          } else {
            disableSizes(size, targetColor);
          }
        });
      });
    });

    if (sizes.length > 0) {


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
