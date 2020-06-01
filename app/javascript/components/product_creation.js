const productCreation = () => {
  const productCreationContainer = document.getElementById('product-creation');

  if (productCreationContainer) {
    // add more size variations
    const addSizeBtn = document.getElementById('add-size');
    addSizeBtn.addEventListener('click', event => {
      const lastVariation = document.querySelector('.size-variation:last-child');
        lastVariation.insertAdjacentHTML('afterend', `
          <div class="size-variation">
            ${lastVariation.innerHTML}
          </div>
        `);
    })

    // add more product photos
    const addPhotosBtn = document.getElementById('add-photos');
    addPhotosBtn.addEventListener('click', event => {
      const lastPhoto = document.querySelector('.product-photo:last-child');
        lastPhoto.insertAdjacentHTML('afterend', `
          <div class="product-photo">
            ${lastPhoto.innerHTML}
          </div>
        `);
    })

  }
}


export { productCreation };
