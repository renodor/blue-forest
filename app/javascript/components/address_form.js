const addressForm = () => {
  // force to trigger add to cart modal if present
  const addressForm = document.querySelector('.shipping-container');

  if (addressForm) {
    const addressDistrict = document.getElementById('address_district');
    const districtInput = document.querySelector('.district');
    const currentDistrict = addressForm.dataset.district;
    const currentArea = addressForm.dataset.area

    const displayCorrectAreas = (district) => {
      const areaInputs= document.querySelectorAll('.areas');
      areaInputs.forEach((areaInput) => {
        if (areaInput.dataset.area == district.toLowerCase()) {
          areaInput.style = 'display: block!important';
          areaInput.name = 'address[area]';
          areaInput.id = 'address_area'
          areaInput.value = currentArea;
        } else {
          areaInput.style = 'display: none!important';
          areaInput.name = '';
          areaInput.id = '';
          if (areaInput.parentNode.querySelector('.invalid-feedback')) {
            areaInput.parentNode.querySelector('.invalid-feedback').style.display = 'none';
          }
        }
      });
    }

    if (currentDistrict) {
      districtInput.value = currentDistrict;
      displayCorrectAreas(currentDistrict);
    } else {
      displayCorrectAreas('panamá');
    }

    addressDistrict.addEventListener('change', event => {
      displayCorrectAreas(event.currentTarget.value);
    });
  }
}

export { addressForm };
