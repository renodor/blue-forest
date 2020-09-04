const productCrationValidation = () => {
  const productCreationTool = document.getElementById('product-creation-container');

  if (productCreationTool) {
    const createProductForm = document.getElementById('product-creation-form');
    const creatProductBtn = createProductForm.querySelector('#create-product');
    let formIsValid;

    // Helper method to add a warning message below an input
    // or to modify the warning message if already present
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

    // Helper method to check if an input as value
    // if no: add 'is-invalid' class to input, add a warning message invalid the form
    // if yes: remove the 'is-invalid' class, and remove the warning message
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

    const checkIfHasProductType = (productTypeObject) => {
      if (!productTypeObject['withColors'] && !productTypeObject['withoutColors']) {
        const productTypeContainer = createProductForm.querySelector('#product-type-container');
        productTypeContainer.querySelectorAll('label').forEach((label) => {
          label.classList.add('is-invalid');
          formIsValid = false;
        });
      } else {
        createProductForm.querySelectorAll('#product-type-container label').forEach((label) => {
          label.classList.remove('is-invalid');
        });
      }
    };

    // Helper method to check if discount price is smaller than normal price
    // if no: add 'is-invalid' class to discount price, add and warning message and invalid the form
    // otherwise remove the 'is-invalid' class and the warning message present
    const checkDiscountPriceVsPrice = (price, discountPrice) => {
      if (discountPrice.value && parseFloat(price.value) <= parseFloat(discountPrice.value)) {
        discountPrice.classList.add('is-invalid');
        formIsValid = false;
        addValidationWarning(discountPrice, 'Discount price must smaller than normal price');
      } else if (discountPrice.classList.contains('is-invalid')) {
        discountPrice.classList.remove('is-invalid');
        discountPrice.nextElementSibling.remove();
      }
    };

    // Method that check all the size variations of the correct product type:
    // - check if variation has a size
    // - check if variation has a price
    // - check if discount price is smaller than normal price
    // - check if variation has a quantity
    const checkSizeVariations = (productType) => {
      const sizeVariations = createProductForm.querySelectorAll(`.${productType} .size-element`);
      sizeVariations.forEach((sizeVariation) => {
        const size = sizeVariation.querySelector('#color_variations__size_variations__size');
        checkIfHasValue(size);

        const price = sizeVariation.querySelector('#color_variations__size_variations__price');
        checkIfHasValue(price);

        /* eslint-disable max-len */
        const discountPrice = sizeVariation.querySelector('#color_variations__size_variations__discount_price');
        /* eslint-enable max-len */
        checkDiscountPriceVsPrice(price, discountPrice);

        const qty = sizeVariation.querySelector('#color_variations__size_variations__quantity');
        checkIfHasValue(qty);
      });
    };

    // Method that check photos of the correct product type:
    // - if one photo element doesn't have a file, add 'is-invalid' class and invalid the form
    // - else if a photo element has a file, remove the 'is-invalid' class
    const checkPhotos = (productType) => {
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

    // Method that check if product has repeated colors
    // we first create an object to count colors
    // if we find repeated color: add 'is-invalid' class to input, warning message and invalid form
    // if color is not repeated and has 'is-invalid' class, removes it and removes warning message
    const checkColorUniqueness = () => {
      const colors = {};
      const colorInputs = document.querySelectorAll('.product-with-color #color_variations__color');

      colorInputs.forEach((colorInput) => {
        colors[colorInput.value] = (colors[colorInput.value] || 0) + 1;

        if (colors[colorInput.value] > 1) {
          colorInput.classList.add('is-invalid');
          addValidationWarning(colorInput, 'Color must be unique');
          formIsValid = false;
        } else if (colorInput.classList.contains('is-invalid')) {
          colorInput.classList.remove('is-invalid');
          colorInput.nextElementSibling.remove();
        }
      });
    };

    // When user tries to create product, prevent form submission, and check validations:
    // - check if product has a name
    // - check if product type is selected
    // - Then for the correct product type: check size variations, photos (and color if needed)
    // when all validations passed, if form is still valid, submit it
    // otherwise scroll to the first error we found
    creatProductBtn.addEventListener('click', (event) => {
      formIsValid = true;
      event.preventDefault();
      const name = createProductForm.querySelector('#name');
      checkIfHasValue(name);

      const productTypeObject = {
        'withColors': createProductForm.querySelector('#product_type_with_colors').checked,
        'withoutColors': createProductForm.querySelector('#product_type_without_colors').checked,
      };

      checkIfHasProductType(productTypeObject);

      if (productTypeObject['withoutColors']) {
        const productType = 'product-without-color';

        checkSizeVariations(productType);
        checkPhotos(productType);
      } else if (productTypeObject['withColors']) {
        const productType = 'product-with-color';

        checkSizeVariations(productType);
        checkPhotos(productType);
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
