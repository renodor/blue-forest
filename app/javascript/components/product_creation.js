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
    const addPhotosBtn = document.getElementById('add-photos');
    addPhotosBtn.addEventListener('click', event => {
      const lastPhoto = document.querySelector('.product-photo');
      lastPhoto.insertAdjacentHTML('afterend', `
        <div class="row product-photo">
          ${lastPhoto.innerHTML}
        </div>
      `);
    })

    const colorVariation = document.querySelector('.color-variation');

    // DRY
    let addSizeToColorBtns = document.querySelectorAll('.add-size-to-color');

    addSizeToColorBtns.forEach((addSizeToColorBtn) => {
      addSizeToColorBtn.addEventListener('click', event => {
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


    // DRY
    // TO CLEAN !! HARDCORE
    const addColorBtn = document.getElementById('add-color');
    let colorId = 1
    addColorBtn.addEventListener('click', event => {
      let lastColor = document.querySelector(`.color-variation[data-id='${colorId}'`);
      const oneSizeVariation = lastColor.querySelectorAll('.size-variation')[0].innerHTML;
      const onePhoto = lastColor.querySelectorAll('.product-photo')[0].innerHTML;
      colorId += 1;
      lastColor.insertAdjacentHTML('afterend', `
        <div class="color-variation" data-id='${colorId}'>
          ${lastColor.innerHTML}
        </div>
      `);
      lastColor = document.querySelector(`.color-variation[data-id='${colorId}'`);
      lastColor.querySelector('.size-variations').innerHTML = `<div class="row size-variation">${oneSizeVariation}`;

      lastColor = document.querySelector(`.color-variation[data-id='${colorId}'`);
      lastColor.querySelector('.product-photos').innerHTML = `<div class="row product-photo">${onePhoto}`;

      addSizeToColorBtns = lastColor.querySelector('.add-size-to-color');
      addSizeToColorBtns.addEventListener('click', event => {
        const targetColorSizeVariations = event.currentTarget.parentNode.querySelectorAll('.size-variation');
        const lastVariation = targetColorSizeVariations[targetColorSizeVariations.length - 1]
         lastVariation.insertAdjacentHTML('afterend', `
            <div class="row size-variation">
              ${lastVariation.innerHTML}
            </div>
          `);
      })

      const addPhotoToColorBtns = lastColor.querySelector('#add-photos-to-color');
      addPhotoToColorBtns.addEventListener('click', event => {
        const targetColorProductPhotos = event.currentTarget.parentNode.querySelectorAll('.product-photo');
        const lastPhoto = targetColorProductPhotos[targetColorProductPhotos.length - 1]
         lastPhoto.insertAdjacentHTML('afterend', `
            <div class="row product-photo">
              ${lastPhoto.innerHTML}
            </div>
          `);
      })
    })
  }
}


export { productCreation };
