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


    const insertNewElement = (lastChildElement, elementToAdd, cssClass, id=null) => {
      lastChildElement.insertAdjacentHTML('afterend', `
        <div class="${cssClass}" ${id ? `data-id='${id}'` : ''}>
          ${elementToAdd}
        </div>
      `);
    }

    const addClickListenerToBtn = (btn, elementToAdd, cssClass) => {
      btn.addEventListener('click', event => {
        const currentColor = document.querySelector(`.color-variation[data-id='${event.currentTarget.dataset.id}'`);
        const lastChildElement = currentColor.querySelector(`.${cssClass}:last-child`);
        insertNewElement(lastChildElement, elementToAdd, `${cssClass}`);
      })
    }

    const savedSizeVariation = document.querySelector('.size-variation').innerHTML;
    const savedProductPhoto = document.querySelector('.product-photo').innerHTML;
    const savedColorVariation = document.querySelector(".color-variation[data-id='1']").innerHTML;

    // add more size variations
    const addSizeBtns = document.querySelectorAll('.add-size');
    addSizeBtns.forEach((addSizeBtn) => {
      addClickListenerToBtn(addSizeBtn, savedSizeVariation, 'size-variation');
    })

    // add more product photos
    // DRY
    const addPhotosBtns = document.querySelectorAll('.add-photos');
    addPhotosBtns.forEach((addPhotosBtn) => {
      addClickListenerToBtn(addPhotosBtn, savedProductPhoto, 'product-photo');
    })

    let colorVariationId = 1

    const addColorBtn = document.querySelector('.add-color');
    addColorBtn.addEventListener('click', event => {
      let lastColorVariation = document.querySelector(`.color-variation[data-id='${colorVariationId}']`);
      colorVariationId += 1
      const updatedColorVariation = savedColorVariation.replace(/(data-id=['"])(\d+)(['"])/g, `$1${colorVariationId}$3`);
      insertNewElement(lastColorVariation, updatedColorVariation, 'color-variation', colorVariationId)

      const newColorAddSizeBtn = document.querySelector(`.add-size[data-id='${colorVariationId}']`);
      addClickListenerToBtn(newColorAddSizeBtn, savedSizeVariation, 'size-variation');

      const newColorAddPhotosBtn = document.querySelector(`.add-photos[data-id='${colorVariationId}']`);
      addClickListenerToBtn(newColorAddPhotosBtn, savedProductPhoto, 'product-photo');
    })
  }
}


export { productCreation };
