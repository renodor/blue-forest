const productCreation = () => {
  const productCreationContainer = document.getElementById('product-creation');

  if (productCreationContainer) {

    // chose product type
    const productWithColorBtn = document.getElementById('product-with-color');
    const productWithColor = document.querySelector('.product-with-color')

    const productWithoutColorBtn = document.getElementById('product-without-color');
    const productWithoutColor = document.querySelector('.product-without-color')


    productWithoutColorBtn.addEventListener('click', event => {
      productWithoutColor.classList.remove('display-none');
      productWithoutColorBtn.style.opacity = '1'

      productWithColor.classList.add('display-none');
      productWithColorBtn.style.opacity = '0.3'
    });

    productWithColorBtn.addEventListener('click', event => {
      productWithColor.classList.remove('display-none');
      productWithColorBtn.style.opacity = '1';

      productWithoutColor.classList.add('display-none');
      productWithoutColorBtn.style.opacity = '0.3';
    });


    // add more size variations
    const addSizeBtn = document.querySelector('.add-size');

    // DRY
    addSizeBtn.addEventListener('click', event => {
      const lastVariation = document.querySelector('.size-variation');
      lastVariation.insertAdjacentHTML('afterend', `
        <div class="row size-variation">
          ${lastVariation.innerHTML}
        </div>
      `);
    })

    // add more product photos
    // DRY
    const addColorBtn = document.getElementById('add-color');
    addColorBtn.addEventListener('click', event => {
      colorVariationId += 1
      const lastColor = document.querySelector('.color-variation');
      lastColor.insertAdjacentHTML('afterend', `
        <div class="color-variation" data-id='${colorVariationId}'>
          ${lastColor.innerHTML}
        </div>
      `);
      addSizeToColorBtns = document.querySelectorAll('.add-size-to-color');
      addSizeToColorBtns[addSizeToColorBtns.length - 1].dataset.id = colorVariationId;
    })

    // DRY
    let addSizeToColorBtns = document.querySelectorAll('.add-size-to-color');

    addSizeToColorBtns.forEach((addSizeToColorBtn) => {
      addSizeToColorBtn.addEventListener('click', event => {
        console.log('yo')
        const lastVariation = document.querySelector('.color-variation .size-variation');
        lastVariation.insertAdjacentHTML('afterend', `
          <div class="row size-variation">
            ${lastVariation.innerHTML}
          </div>
        `);
      })
    })

    // add more product photos
    // DRY
    const addPhotosBtn = document.getElementById('add-photos');
    addPhotosBtn.addEventListener('click', event => {
      const lastPhoto = document.querySelector('.product-photo');
      lastPhoto.insertAdjacentHTML('afterend', `
        <div class="row product-photo">
          ${lastPhoto.innerHTML}
        </div>
      `);
    })

    // add more product photos
    // DRY
    const addPhotosToColorBtn = document.getElementById('add-photos-to-color');
    let colorVariationId = 1
    addPhotosToColorBtn.addEventListener('click', event => {
      const lastPhoto = document.querySelector('.color-variation .product-photo');
      lastPhoto.insertAdjacentHTML('afterend', `
        <div class="row product-photo">
          ${lastPhoto.innerHTML}
        </div>
      `);
    })

  }
}


export { productCreation };
