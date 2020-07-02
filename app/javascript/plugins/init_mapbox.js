import mapboxgl from 'mapbox-gl';

const initMapbox = () => {

  const mapDiv = document.querySelector('.map');
  const createAddressMap = document.getElementById('create-address-map');
  const showAddressMap = document.getElementById('show-address-map');
  if (mapDiv) {

    const addressDistrict = document.getElementById('address_district');
    const addressAreas = document.querySelectorAll('.address_area .areas');
    const currentArea = document.querySelector('.shipping-container').dataset.area;

    // Get latitude and longitude hidden inputs
    const latitudeInput = document.getElementById('address_latitude');
    const longitudeInput = document.getElementById('address_longitude');

    // manually define coordinates of panama areas (mapbox doesn't find it...)
    const areaCoordinates = {
      'Bella Vista': [-79.526022, 8.983972],
      'Ancón': [-79.549556, 8.959927],
      'Calidonia': [-79.535817, 8.968804],
      'Amelia Denis de Icaza': [-79.5128063,9.0411865]
    }

    let coordinates;

    // Method that update the value of latitude and longitude hidden inputs
    const updateCoordinates = () => {
      latitudeInput.value = marker.getLngLat().lat;
      longitudeInput.value = marker.getLngLat().lng;
    }

    // initialize a mapbox map in the center of Panama
    mapboxgl.accessToken = createAddressMap.dataset.mapboxApiKey;
    const map = new mapboxgl.Map({
      container: 'create-address-map',
      center: [-79.528142, 8.975448], // by default showing Panama
      zoom: 15,
      style: 'mapbox://styles/mapbox/streets-v10'
    });

    // Create a new draggable market on the map, and put it by default in the center of Panama
    const marker = new mapboxgl.Marker({
      draggable: true
    })
    .setLngLat([-79.528142, 8.975448])
    .addTo(map);

    // Every time the marker is dragged, call updateCoordinates method
    marker.on('dragend', updateCoordinates);

    // Add en event listener on the area (corregimiento) field
    // and update the map each time it changes
    addressAreas.forEach((addressArea) => {
      addressArea.addEventListener('change', event => {
        // if the map is not visible (first time you arrive on 'new address'), display it
        if (mapDiv.classList.contains('display-none')) {
          mapDiv.classList.remove('display-none');
        }
        // Then we need to do 3 things :
        // - put the marker on the center of the selected area
        // - resize the map
        // - put the center of the map on the selected area
        coordinates = areaCoordinates[addressArea.value]
        marker.setLngLat(coordinates);
        map.resize();
        map.flyTo({ center: coordinates });
        latitudeInput.value = longitudeInput.value = null
      });
    });

    // if user is editing an address, it already has lat and long
    // in that case we just need to update the map
    if (createAddressMap.dataset.lng && createAddressMap.dataset.lat) {
      coordinates = [createAddressMap.dataset.lng, createAddressMap.dataset.lat]
      marker.setLngLat(coordinates);
      map.resize();
      map.flyTo({ center: coordinates });
    // if there are no lat and long but already a selected area,
    // it means the form has been rendered ('render new') again because it was invalid
    // in that case we also need to resize map, set new area coordinate to marker, and center the map to thos coordinates
    // (we do that insidde a SetTimeout otherwise Mapbox has a small display bug...)
    } else if (currentArea) {
      mapDiv.classList.remove('display-none');
      setTimeout(() => {
        map.resize();
        coordinates = areaCoordinates[currentArea]
        marker.setLngLat(coordinates);
        map.flyTo({ center: coordinates });
      }, 500);
    }
  }

  // Static map when showing addresse
  if (showAddressMap) {
    // I need to wait 0.5 second before showing the map...
    // otherwise JS/CSS doesnt load properly and the map is not centered.
    // Don't know why.. Probably because of turbolink or something...
    setTimeout(() => {
      mapboxgl.accessToken = showAddressMap.dataset.mapboxApiKey;
      const map = new mapboxgl.Map({
        container: 'show-address-map',
        style: 'mapbox://styles/mapbox/streets-v10',
        center: [showAddressMap.dataset.lng, showAddressMap.dataset.lat], // by default showing address location
        zoom: 15
      });

      new mapboxgl.Marker()
        .setLngLat([ showAddressMap.dataset.lng, showAddressMap.dataset.lat ])
        .addTo(map);
    }, 500);
  };
};

export { initMapbox };
