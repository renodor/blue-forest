const pdpVariations = () => {
  const pdpContainer = document.querySelector('.pdp-container');
  if (pdpContainer) {
    // select sizes and colors inputs
    const sizes = document.querySelectorAll('.pdp .sizes input');
    const colors = document.querySelectorAll('.pdp .colors input');

    const atc = document.querySelector('.pdp .atc');
    const atcOverlay = document.querySelector('.pdp .atc-overlay');
    const warning = document.querySelector('.size-selection-warning');

    // helper method to reset atc and warning message when a new color is selected:
    // - disable atc
    // - enable atc overlay
    // - disable warning
    // - reset warning to its 'default' message
    // - reset atc button with its 'default' text
    const resetAtc = () => {
      atc.disabled = true;
      atcOverlay.style.display = 'block';
      warning.style.display = 'none';
      warning.innerHTML = 'Por favor seleccionar una talla';
      atc.querySelectorAll('span')[1].innerHTML = 'COMPRAR';
    };

    // helper method to disable sizes that don't belong to the selected color
    // and to display-none sizes that are repeated accross colors
    const disableSizes = (size, targetColor, first) => {
      // if size belong to current selected color we do 2 things:
      // 1. enable size
      // 2. make sure that size label is displayed
      //    (if this size is repeated it may have been hidden before)
      if (size.dataset.color == targetColor) {
        size.disabled = false;
        document.querySelector(`label[for=variation_id_${size.value}]`)
            .style.display = 'inline-block';

      // if size doesn't belong to current selected color, we do 3 things
      // 1. uncheck size (to make sure no size remain checked if user change color seleccion)
      // 2. disable size
      // 3. check if size is repeated for the current target color, if yes hide its label
      //    (to avoid repeated sizes on front end)
      } else {
        size.checked = false;
        size.disabled = true;
        if (size.dataset.repeatedFor.match(targetColor)) {
          document.querySelector(`label[for=variation_id_${size.value}]`).style.display = 'none';
        }
      }
    };

    // simple healper method for 'unique' sizes
    // if size is unique, and there are several colors, for the clicked color we need to
    // - enable and check the size of the target color
    // - check if this size has stock, if yes disable atcOverlay, enable atc, disable warning
    // - if this size has no stoc, enable atcOverlay, disable atc, enable warning
    // and disable and uncheck the other sizes
    const uniqueSizesToggle = (size, targetColor) => {
      if (size.dataset.color === targetColor) {
        size.disabled = false;
        size.checked = true;
        if (size.dataset.quantity > 0) {
          atc.disabled = false;
          atcOverlay.style.display = 'none';
          atc.querySelectorAll('span')[1].innerHTML = 'COMPRAR';
          warning.style.display = 'none';
        } else {
          atc.disabled = true;
          atcOverlay.style.display = 'block';
          atc.querySelectorAll('span')[1].innerHTML = 'AGOTADO';
          warning.innerHTML = 'Este producto está agotado';
        }
      } else {
        size.disabled = true;
        size.checked = false;
      };
    };

    // making sure that there is more than 1 color. Otherwise the color option is not even displayed
    if (colors.length > 1) {
      // when page load, select the checked color (the one of the main photo)
      // and call our 'disableSizes' method on this color
      const targetColor = document.querySelector('.pdp .colors input:checked').value;
      sizes.forEach((size) => {
        // if size is 'unique', call a different method
        if (size.dataset.unique) {
          uniqueSizesToggle(size, targetColor);
        } else {
          disableSizes(size, targetColor);
        }
      });
    }

    // add event listener on color selection
    // when user select a color, we need to call our 'disableSizes' method on the selected color
    // and our 'resetATC' method
    colors.forEach((color) => {
      color.addEventListener('click', (event) => {
        sizes.forEach((size, i) => {
          const targetColor = color.value;
          // if size is 'unique', call a different method
          if (size.dataset.unique) {
            uniqueSizesToggle(size, targetColor);
          } else {
            resetAtc();
            disableSizes(size, targetColor);
          }
        });
      });
    });

    // making sure that there is more than 1 size. Otherwise the size option is not even displayed
    if (sizes.length > 1) {
      // disable add to cart button by default
      atc.disabled = true;

      // When a size is checked, disable the warning message.
      // then if size has quantity :
      // - disable the overlay
      // - reset atc message to 'buy'
      // - and enable the add to cart button

      // if size is out of stock :
      // - enable the overlay
      // - disable the atc
      // - set the atc message to 'out of stock'
      // - set the warning message to out of stock message
      sizes.forEach((size) => {
        size.addEventListener('click', (event) => {
          if (size.checked) {
            warning.style.display = 'none';
            if (size.dataset.quantity > 0) {
              atcOverlay.style.display = 'none';
              atc.querySelectorAll('span')[1].innerHTML = 'COMPRAR';
              atc.disabled = false;
            } else {
              atcOverlay.style.display = 'block';
              atc.disabled = true;
              atc.querySelectorAll('span')[1].innerHTML = 'AGOTADO';
              warning.innerHTML = 'Este producto está agotado';
            }
          }
        });
      });
    // if there is only one size, check if unique size has quantity
    // if yes we can disable atcOverlay
    } else if (sizes[0].dataset.quantity > 0) {
      atcOverlay.style.display = 'none';

      // we also make sure that unique size is checked
      // unique sizes should be checked by default if they have the correct name 'unique',
      // but if for some reason its not the case, we make sur of it here
      sizes[0].checked = true; // unique sizes should be checked by

    // if not it means the unique size is out of stock,
    // thus we need to disable atc, update atc text and warning message
    } else {
      atc.disable = true;
      atc.querySelectorAll('span')[1].innerHTML = 'AGOTADO';
      warning.innerHTML = 'Este producto está agotado';
    }

    // if the atc is disable, there is an atcOverlay
    // if there is a click on atcOverlay show a warning message
    // (we need to have a add to cart overlay for that because disabled button don't trigger events)
    atcOverlay.addEventListener('click', (event) => {
      warning.style.display = 'block';
    });
  };
};

export {pdpVariations};
