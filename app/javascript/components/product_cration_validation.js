const productCrationValidation = () => {
  const productCreationTool = document.getElementById('product-creation-container');

  if (productCreationTool) {
    const createProductForm = document.getElementById('product-creation-form');
    const creatProductBtn = createProductForm.querySelector('#create-product');
    let formIsValid;

    const addValidationWarning = (element, message) => {
      const nextElement = element.nextElementSibling;
      if (nextElement && nextElement.classList.contains('input-warning')) {
        nextElement.innerHTML = message;
      } else {
        element.insertAdjacentHTML('afterend', `
        <span class="input-warning" style="color:red;">
          ${message}
        </span>`);
      }
    };

    const checkIfHasValue = (element) => {
      if (!element.value) {
        element.classList.add('is-invalid');
        addValidationWarning(element, `Please chose a ${element.previousElementSibling.innerHTML}`);
        formIsValid = false;
      } else if (element.classList.contains('is-invalid')) {
        element.classList.remove('is-invalid');
        element.nextElementSibling.remove();
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

        /* eslint-disable max-len */
        const discountPrice = sizeVariation.querySelector('#color_variations__size_variations__discount_price');
        /* eslint-enable max-len */
        if (discountPrice.value && price.value <= discountPrice.value) {
          discountPrice.classList.add('is-invalid');
          addValidationWarning(discountPrice, 'Discount price must smaller than normal price');
        } else if (discountPrice.classList.contains('is-invalid')) {
          discountPrice.classList.remove('is-invalid');
          discountPrice.nextElementSibling.remove();
        }

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

    const checkColorUniqueness = () => {
      const colors = {};
      /* eslint-disable max-len */
      document.querySelectorAll('.product-with-color #color_variations__color').forEach((colorVariation) => {
      /* eslint-enable max-len */
        if (colorVariation.classList.contains('is-invalid')) {
          colorVariation.classList.remove('is-invalid');
          colorVariation.nextElementSibling.remove();
        }

        if (!colors[colorVariation.value]) {
          colors[colorVariation.value] = 1;
        } else {
          colors[colorVariation.value] += 1;
          colorVariation.classList.add('is-invalid');
          addValidationWarning(colorVariation, 'Color must be unique');
          formIsValid = false;
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
        checkColorUniqueness();
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
