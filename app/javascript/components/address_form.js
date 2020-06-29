const addressForm = () => {
  // force to trigger add to cart modal if present
  const addressForm = document.querySelector('.shipping-container');

  if (addressForm) {
    const addressDistrict = document.getElementById('address_district');
    const panamaDistricts = document.querySelector('.panama-districts');
    const sanMiguelitoDistricts = document.querySelector('.san-miguelito-districts');

    sanMiguelitoDistricts.style = 'display: none!important';
    sanMiguelitoDistricts.name = '';
    sanMiguelitoDistricts.id = '';

    addressDistrict.addEventListener('change', event => {
      if (event.currentTarget.value == 'Panamá') {
        sanMiguelitoDistricts.style = 'display: none!important';
        sanMiguelitoDistricts.name = '';
        sanMiguelitoDistricts.id = '';

        panamaDistricts.style = 'display: block!important';
        panamaDistricts.name = 'address[area]';
        panamaDistricts.id = 'address_area'
      } else {
        panamaDistricts.style = 'display: none!important';
        panamaDistricts.name = '';
        panamaDistricts.id = '';

        sanMiguelitoDistricts.style = 'display: block!important';
        sanMiguelitoDistricts.name = 'address[area]';
        sanMiguelitoDistricts.id = 'address_area'
      }
    })
  }
}

export { addressForm };
