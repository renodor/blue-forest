const productCrationValidation = () => {
  const productCreationTool = document.getElementById('product-creation-container');

  if (productCreationTool) {
    const createProductForm = document.getElementById('product-creation-form');
    const creatProductBtn = createProductForm.querySelector('#create-product');
    let formIsValid;

    const checkIfHasValue = (element) => {
      if (!element.value) {
        element.classList.add('is-invalid');
        formIsValid = false;
      } else if (element.classList.contains('is-invalid')) {
        element.classList.remove('is-invalid');
      }
    };

    const checkSizeVariations = (productType) => {
      createProductForm.querySelectorAll('#product-type-container label').forEach((label) => {
        label.classList.remove('is-invalid');
      });
      const sizeVariations = createProductForm.querySelectorAll(`.${productType} .size-element`);
      sizeVariations.forEach((sizeVariation) => {
        const size = sizeVariation.querySelector('#color_variations__size_variations__size');
        checkIfHasValue(size);

        const price = sizeVariation.querySelector('#color_variations__size_variations__price');
        checkIfHasValue(price);

        const qty = sizeVariation.querySelector('#color_variations__size_variations__quantity');
        checkIfHasValue(qty);
      });

      const photoElements = createProductForm.querySelectorAll(`.${productType} .photo-element`);
      photoElements.forEach((photoElement) => {
        const photoInput = photoElement.querySelector('#color_variations__photos__photo');
        if (photoInput.files.length == 0) {
          photoInput.classList.add('is-invalid');
          formIsValid = false;
        } else if (photoInput.files.length == 1) {
          photoInput.classList.remove('is-invalid');
        }
      });
    };

    creatProductBtn.addEventListener('click', (event) => {
      formIsValid = true;
      event.preventDefault();
      const name = createProductForm.querySelector('#name');
      const productWithColors = createProductForm.querySelector('#product_type_with_colors');
      const productWithoutColors = createProductForm.querySelector('#product_type_without_colors');
      checkIfHasValue(name);

      if (!productWithColors.checked && !productWithoutColors.checked) {
        const productTypeContainer = createProductForm.querySelector('#product-type-container');
        productTypeContainer.querySelectorAll('label').forEach((label) => {
          label.classList.add('is-invalid');
          formIsValid = false;
        });
      } else if (productWithoutColors.checked) {
        checkSizeVariations('product-without-color');
      } else if (productWithColors.checked) {
        checkSizeVariations('product-with-color');
      }
      if (formIsValid) {
        createProductForm.submit();
      } else {
        const firstInvalidElement = document.querySelector('.is-invalid');
        firstInvalidElement.parentNode.scrollIntoView();
      }
    });
  }
};

export {productCrationValidation};
