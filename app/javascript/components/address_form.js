const addressForm = () => {
  const addressForm = document.querySelector('.shipping-container');

  if (addressForm) {
    const addressDistrict = document.getElementById('address_district');
    const districtInput = document.querySelector('.district');
    const currentDistrict = addressForm.dataset.district;
    const currentArea = addressForm.dataset.area

    // helper method to display correct areas regarding what district is selected
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

    // if there is a current district, it means we user is trying to edit its address
    // in that case we need to put the correct district and area values (regarding the current district)
    // otherwise we just display Panama district and areas by default
    if (currentDistrict) {
      districtInput.value = currentDistrict;
      displayCorrectAreas(currentDistrict);
    } else {
      displayCorrectAreas('panamá');
    }

    // every time district is updated, we need to update the areas as well
    addressDistrict.addEventListener('change', event => {
      displayCorrectAreas(event.currentTarget.value);
    });
  }
}

export { addressForm };
