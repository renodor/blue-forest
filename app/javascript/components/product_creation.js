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


    const insertNewElement = (lastChildElement, elementType, id=null) => {
      let elementToAdd = eval(`${elementType}Element`);

      if (id) {
        elementToAdd = elementToAdd.replace(/(data-id=['"])(\d+)(['"])/g, `$1${id}$3`);
      }

      lastChildElement.insertAdjacentHTML('afterend', `
        <div class="${elementType}-element" ${id ? `data-id='${id}'` : ''}>
          ${elementToAdd}
        </div>
      `);
    }

    const addClickListenerToBtn = (btn) => {
      btn.addEventListener('click', event => {
        const elementType = event.currentTarget.dataset.type;
        const currentColor = document.querySelector(`.color-element[data-id='${event.currentTarget.dataset.id}'`);
        const lastChildElement = currentColor.querySelector(`.${elementType}-element:last-child`);
        insertNewElement(lastChildElement, elementType);
      })
    }

    const sizeElement = document.querySelector('.size-element').innerHTML;
    const photoElement = document.querySelector('.photo-element').innerHTML;
    const colorElement = document.querySelector(".color-element[data-id='1']").innerHTML;

    // add more size variations
    const addElementBtns = document.querySelectorAll('.add-element');
    addElementBtns.forEach((addElementBtn) => {
      addClickListenerToBtn(addElementBtn);
    })

    let colorVariationId = 1

    const addColorBtn = document.querySelector('.add-color');
    addColorBtn.addEventListener('click', event => {
      let lastColorVariation = document.querySelector(`.color-element[data-id='${colorVariationId}']`);
      colorVariationId += 1
      insertNewElement(lastColorVariation, event.currentTarget.dataset.type, colorVariationId)

      const newColorAddElementBtns = document.querySelectorAll(`.add-element[data-id='${colorVariationId}']`);
      console.log(newColorAddElementBtns)
      newColorAddElementBtns.forEach((newColorAddElementBtn) => {
        addClickListenerToBtn(newColorAddElementBtn);
      });
    })
  }
}


export { productCreation };
