const productCreation = () => {
  const productCreationContainer = document.getElementById('product-creation');

  if (productCreationContainer) {

    // chose product type
    const productWithColorBtn = document.getElementById('product-with-color');
    const productWithColorDiv = document.querySelector('.product-with-color')

    const productWithoutColorBtn = document.getElementById('product-without-color');
    const productWithoutColorDiv = document.querySelector('.product-without-color')

    // show the correct product type creation form regarding what type is selected
    productWithoutColorBtn.addEventListener('click', event => {
      productWithoutColorDiv.classList.remove('display-none');
      productWithoutColorBtn.style.opacity = '1'

      productWithColorDiv.classList.add('display-none');
      productWithColorBtn.style.opacity = '0.3'
    });

    productWithColorBtn.addEventListener('click', event => {
      productWithColorDiv.classList.remove('display-none');
      productWithColorBtn.style.opacity = '1';

      productWithoutColorDiv.classList.add('display-none');
      productWithoutColorBtn.style.opacity = '0.3';
    });


    // method to insert a new element on the DOM regarding its type and its ID
    const insertNewElement = (elementType, id) => {
      // retrieve the element to add regarding the element type
      // it get the correct HTML text by transforming the string elementType+Element to a variable name
      let elementToAdd = eval(`${elementType}Element`);

      // select a lastChildElement (after witch the new element will be added)
      // we need to select the last element of the correct color variation (thus the data-id and :last-child selectors)
      const lastChildElement = document.querySelector(`.${elementType}-element[data-id='${id}']:last-child`);

      // if the element to add is a new color variation, we need to do some specific work
      if (elementType === 'color') {
        // first we need to increment the color variation id count
        colorVariationId += 1
        // then we update the current id to have to be the correct one
        id = colorVariationId
        // then we need to update the HTML text of the element to add with the new id
        // with a regex we target all date-id='x' substring and replace the x with the new id
        elementToAdd = elementToAdd.replace(/(data-id=['"])(\d+)(['"])/g, `$1${id}$3`);
      }

      // we can then insert the new element after the last element of the same type into the correct color variation
      lastChildElement.insertAdjacentHTML('afterend', `
        <div class="${elementType}-element" data-id='${id}'>
          ${elementToAdd}
        </div>
      `);
    }

    // method to add a click event onto a specific btn
    const addClickListenerToBtn = (btn) => {
      btn.addEventListener('click', event => {
        const elementType = event.currentTarget.dataset.type;
        const elementId = event.currentTarget.dataset.id;

        // if the btn is meant to add a new color variation, we need to do some specific work
        if (elementType === 'color') {
          // we need to add a new element but with the id of the colorVariationId count
          // (and not with the id of the clicked btn)
          insertNewElement(elementType, colorVariationId);

          // we then need to select all the new btns that appeared on the DOM after the new color variation was created
          // (add size and add photo btns)
          // and wee need to call this same method again for those new buttons
          const newColorAddElementBtns = document.querySelectorAll(`.add-element[data-id='${colorVariationId}']`);
          newColorAddElementBtns.forEach((newColorAddElementBtn) => {
            addClickListenerToBtn(newColorAddElementBtn);
          });
        } else {
          // if we don't need to add a new color, just call the method to add a new element with the id of the clicked btn
          insertNewElement(elementType, elementId);
        }
      })
    }

    // save the HTML of a size variation, a product photo and a color variation elements
    const sizeElement = document.querySelector('.size-element').innerHTML;
    const photoElement = document.querySelector('.photo-element').innerHTML;
    const colorElement = document.querySelector(".color-element[data-id='1']").innerHTML;

    // initialize the color variation id count at 1
    // (the color variation with id 0 is actually for product without color variations)
    let colorVariationId = 1

    // select all the btns meant to add new elements to the DOM
    const addElementBtns = document.querySelectorAll('.add-element');
    addElementBtns.forEach((addElementBtn) => {
      // for each btn, call the method that add listen click events
      addClickListenerToBtn(addElementBtn);
    })
  }
}


export { productCreation };
