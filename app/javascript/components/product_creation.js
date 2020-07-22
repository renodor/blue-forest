const productCreation = () => {
  const productCreationContainer = document.getElementById('product-creation');

  if (productCreationContainer) {
    // method to check first photo of a product type as the main one
    // (we will use it to be sure there is always at least one photo selected as 'main photo')
    const checkFirstPhoto = (productType) => {
      const css = `.product-${productType} .photo-element #color_variations__photos__main_true`;
      const firstPhoto = document.querySelector(css);
      firstPhoto.checked = true;
    };

    // CHOSE PRODUCT TYPE

    // select the btn and the div for both product types
    const productWithColorBtn = document.getElementById('product-with-color');
    const productWithColorDiv = document.querySelector('.product-with-color');

    const productWithoutColorBtn = document.getElementById('product-without-color');
    const productWithoutColorDiv = document.querySelector('.product-without-color');

    // show the correct product type creation form regarding what type is selected
    productWithoutColorBtn.addEventListener('click', (event) => {
      productWithoutColorDiv.classList.remove('display-none');
      productWithoutColorBtn.style.opacity = '1';

      productWithColorDiv.classList.add('display-none');
      productWithColorBtn.style.opacity = '0.3';

      // then automatically check the first photo of product without color as the main photo
      checkFirstPhoto('without-color');
    });

    productWithColorBtn.addEventListener('click', (event) => {
      productWithColorDiv.classList.remove('display-none');
      productWithColorBtn.style.opacity = '1';

      productWithoutColorDiv.classList.add('display-none');
      productWithoutColorBtn.style.opacity = '0.3';

      // then automatically check the first photo of product with color as the main photo
      checkFirstPhoto('with-color');
    });

    // ADD ELEMENTS

    // method to listen clicks on 'remove element'
    // when a remove element is clicked it will remove from DOM its node parent
    const addClickListenerToRemoveElement = (removeElement) => {
      removeElement.addEventListener('click', (event) => {
        // select the node parent of the clicked element
        const elementToRemove = event.currentTarget.parentNode;
        const elementType = event.currentTarget.dataset.type;

        // and remove it
        elementToRemove.remove();
        // if the element to remove is a color element, we need to do specific work
        if (elementType === 'color') {
          // select the Id of last color variation that remain on DOM
          const colorCss = '.color-variations .color-element:last-child';
          const lastColorVariationId = document.querySelector(colorCss).dataset.id;
          // update the color variation id count so that it has the correct id
          // otherwise, if the last color variation is deleted,
          // the color variation id count won't be correct
          // and we won't be able to add a new color variation element
          colorVariationId = parseInt(lastColorVariationId);

          // we also check if any of the product photos of this removed color was the 'main photo'
          // if yes, we call our checkFirstPhoto method on the product with color type
          const photosCss = '.product-photos .photo-element #color_variations__photos__main_true';
          elementToRemove.querySelectorAll(photosCss).forEach((mainPhoto) => {
            if (mainPhoto.checked) {
              checkFirstPhoto('with-color');
            }
          });
        }

        // if the element to remove is a photo, we check if this photo was not the 'main photo'
        // if yes, we call our 'checkFirstPhoto' method on the correct product type
        const mainPhotoCss = '#color_variations__photos__main_true';
        if (elementType === 'photo' && elementToRemove.querySelector(mainPhotoCss).checked) {
          if (document.querySelector('#product_type_with_colors').checked) {
            checkFirstPhoto('with-color');
          } else {
            checkFirstPhoto('without-color');
          }
        }
      });
    };

    // method to insert a new element on the DOM regarding its type and its ID
    const insertNewElement = (elementType, id) => {
      // retrieve the element to add regarding the element type
      // it get the good HTML text by transforming the string elementTypeElement to a variable name
      let elementToAdd = eval(`${elementType}Element`);
      console.log(elementToAdd);

      // select a lastChildElement (after witch the new element will be added)
      // we need to select the last element of the correct color variation
      // (thus the data-id and :last-child selectors)
      const lastElementCss = `.${elementType}-element[data-id='${id}']:last-child`;
      const lastChildElement = document.querySelector(lastElementCss);

      // if the element to add is a new color variation, we need to do some specific work
      if (elementType === 'color') {
        // first we need to increment the color variation id count
        colorVariationId += 1;
        // then we update the current id to have to be the correct one
        id = colorVariationId;
        // then we need to update the HTML text of the element to add with the new id
        // with a regex we target all date-id='x' substring and replace the x with the new id
        elementToAdd = elementToAdd.replace(/(data-id=['"])(\d+)(['"])/g, `$1${id}$3`);
      }

      // we can then insert the new element after the last element of the same type
      // into the correct color variation
      lastChildElement.insertAdjacentHTML('afterend', `
        <div class="${elementType}-element" data-id='${id}'>
          <div class="remove-element" data-type='${elementType}'>
            <i class="fas fa-trash-alt"></i>
          </div>
          ${elementToAdd}
        </div>
      `);

      // we then need to select the 'remove' link of this newly created element
      const removeLinkCss = `.${elementType}-element[data-id='${id}']:last-child .remove-element`;
      const removeElement = document.querySelector(removeLinkCss);

      // and add an event listener on it so that it removes the element when clicked
      addClickListenerToRemoveElement(removeElement);
    };

    // method to add a click event onto a specific btn
    const addClickListenerToBtn = (btn) => {
      btn.addEventListener('click', (event) => {
        const elementType = event.currentTarget.dataset.type;
        const elementId = event.currentTarget.dataset.id;

        // if the btn is meant to add a new color variation, we need to do some specific work
        if (elementType === 'color') {
          // we need to add a new element but with the id of the colorVariationId count
          // (and not with the id of the clicked btn)
          insertNewElement(elementType, colorVariationId);

          // we then need to select all the new btns that appeared on the DOM,
          // after the new color variation was created
          // (add size and add photo btns)
          // and wee need to call this same method again for those new buttons
          const addElementCss = `.add-element[data-id='${colorVariationId}']`;
          const newColorAddElementBtns = document.querySelectorAll(addElementCss);
          newColorAddElementBtns.forEach((newColorAddElementBtn) => {
            addClickListenerToBtn(newColorAddElementBtn);
          });
        } else {
          // if we don't need to add a new color,
          // just call the method to add a new element with the id of the clicked btn
          insertNewElement(elementType, elementId);
        }
      });
    };

    // save the HTML of a size variation, a product photo and a color variation elements
    /* eslint-disable no-unused-vars */
    const sizeElement = document.querySelector('.size-element').innerHTML;
    const photoElement = document.querySelector('.photo-element').innerHTML;
    const colorElement = document.querySelector('.color-element[data-id="1"]').innerHTML;
    /* eslint-enable no-unused-vars */

    // initialize the color variation id count at 1
    // (the color variation with id 0 is actually for product without color variations)
    let colorVariationId = 1;

    // select all the btns meant to add new elements to the DOM
    const addElementBtns = document.querySelectorAll('.add-element');
    addElementBtns.forEach((addElementBtn) => {
      // for each btn, call the method that add listen click events
      addClickListenerToBtn(addElementBtn);
    });

    // REMOVE ELEMENTS
  }
};


export {productCreation};
