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
      // retrieve the current color variation (the color variation with id 0 is actually a product without color variations)
      const currentColor = document.querySelector(`.color-element[data-id='${id}'`);
      let elementToAdd = eval(`${elementType}Element`);
      let lastChildElement;

      if (elementType === 'color') {
        lastChildElement = document.querySelector('.color-variations .color-element:last-child')
        elementToAdd = elementToAdd.replace(/(data-id=['"])(\d+)(['"])/g, `$1${id}$3`);
      } else {
        lastChildElement = currentColor.querySelector(`.${elementType}-element:last-child`);
      }


      lastChildElement.insertAdjacentHTML('afterend', `
        <div class="${elementType}-element" data-id='${id}'>
          ${elementToAdd}
        </div>
      `);
    }

    const addClickListenerToBtn = (btn) => {
      btn.addEventListener('click', event => {
        const elementType = event.currentTarget.dataset.type;
        const elementId = event.currentTarget.dataset.id;

        if (elementType === 'color') {
          colorVariationId += 1
          insertNewElement(elementType, colorVariationId);

          const newColorAddElementBtns = document.querySelectorAll(`.add-element[data-id='${colorVariationId}']`);
          newColorAddElementBtns.forEach((newColorAddElementBtn) => {
            addClickListenerToBtn(newColorAddElementBtn);
          });

        } else {
          insertNewElement(elementType, elementId);
        }
      })
    }

    const sizeElement = document.querySelector('.size-element').innerHTML;
    const photoElement = document.querySelector('.photo-element').innerHTML;
    const colorElement = document.querySelector(".color-element[data-id='1']").innerHTML;

    let colorVariationId = 1

    // add more size variations
    const addElementBtns = document.querySelectorAll('.add-element');
    addElementBtns.forEach((addElementBtn) => {
      addClickListenerToBtn(addElementBtn);
    })
  }
}


export { productCreation };
