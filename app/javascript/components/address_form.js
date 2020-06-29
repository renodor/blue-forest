const addressForm = () => {
  // force to trigger add to cart modal if present
  const addressForm = document.querySelector('.shipping-container');

  if (addressForm) {
    const addressDistrict = document.getElementById('address_district');
    const panamaDistricts = document.querySelector('.panama-districts');
    const sanMiguelitoDistricts = document.querySelector('.san-miguelito-districts');
    const currentDistrict = addressForm.dataset.district;
    const currentArea = addressForm.dataset.area

    const displayCorrectAreas = (district) => {
      const correctAreas = document.querySelectorAll('.areas');

      correctAreas.forEach((correctArea) => {
        if (correctArea.dataset.area == district.toLowerCase()) {
          correctArea.style = 'display: block!important';
          correctArea.name = 'address[area]';
          correctArea.id = 'address_area'
          correctArea.value = currentArea;
        } else {
          correctArea.style = 'display: none!important';
          correctArea.name = '';
          correctArea.id = '';
        }
      });
    }

    if (currentDistrict) {
      displayCorrectAreas(currentDistrict);
    }


    addressDistrict.addEventListener('change', event => {
      displayCorrectAreas(event.currentTarget.value);
    });
  }
}

export { addressForm };
