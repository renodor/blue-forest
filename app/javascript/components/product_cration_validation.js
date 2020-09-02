const productCrationValidation = () => {
  const productCreationTool = document.getElementById('product-creation-container');

  if (productCreationTool) {
    const createProductForm = document.getElementById('product-creation-form');
    const creatProductBtn = createProductForm.querySelector('#create-product');

    creatProductBtn.addEventListener('click', (event) => {
      let formIsValid = true;
      event.preventDefault();
      const name = createProductForm.querySelector('#name');
      const productWithColors = createProductForm.querySelector('#product_type_with_colors');
      const productWithoutColors = createProductForm.querySelector('#product_type_without_colors');
      if (!name.value) {
        name.classList.add('is-invalid');
        formIsValid = false;
      } else if (name.classList.contains('is-invalid')) {
        name.classList.remove('is-invalid');
      }

      if (!productWithColors.checked && !productWithoutColors.checked) {
        const productTypeContainer = createProductForm.querySelector('#product-type-container');
        productTypeContainer.querySelectorAll('label').forEach((label) => {
          label.style.border = '4px solid red';
          formIsValid = false;
        });
      }
      /* eslint-disable max-len */
      if (productWithoutColors.checked) {
        createProductForm.querySelector('#product-type-container').querySelectorAll('label').forEach((label) => {
          label.style.border = 'none';
        });
        const sizeVariations = createProductForm.querySelectorAll('.product-without-color .size-element');
        sizeVariations.forEach((sizeVariation) => {
          const size = sizeVariation.querySelector('#color_variations__size_variations__size');
          if (!size.value) {
            size.classList.add('is-invalid');
            formIsValid = false;
          } else if (size.classList.contains('is-invalid')) {
            size.classList.remove('is-invalid');
          }

          const price = sizeVariation.querySelector('#color_variations__size_variations__price');
          if (!price.value) {
            price.classList.add('is-invalid');
            formIsValid = false;
          } else if (price.classList.contains('is-invalid')) {
            price.classList.remove('is-invalid');
          }

          const quantity = sizeVariation.querySelector('#color_variations__size_variations__quantity');
          if (!quantity.value) {
            quantity.classList.add('is-invalid');
            formIsValid = false;
          } else if (quantity.classList.contains('is-invalid')) {
            quantity.classList.remove('is-invalid');
          }
        });

        const photoElements = createProductForm.querySelectorAll('.product-without-color .photo-element');
        photoElements.forEach((photoElement) => {
          const photoInput = photoElement.querySelector('#color_variations__photos__photo');
          if (photoInput.files.length == 0) {
            photoInput.style.border = '2px solid red';
            formIsValid = false;
          } else if (photoInput.files.length == 1) {
            photoInput.style.border = 'none';
          }
        });
      }
      /* eslint-enable max-len */
      if (formIsValid) {
        createProductForm.submit();
      }
    });
  }
};

export {productCrationValidation};
