import mapboxgl from 'mapbox-gl';

const initMapbox = () => {

  const mapDiv = document.querySelector('.map');
  if (mapDiv) {

    const createAddressMap = document.getElementById('create-address-map');
    const showAddressMap = document.getElementById('show-address-map');
    const addressDistrict = document.getElementById('address_district');
    const addressAreas = document.querySelectorAll('.address_area .areas');

    const currentArea = document.querySelector('.shipping-container').dataset.area;

    // Get latitude and longitude hidden inputs
    const latitudeInput = document.getElementById('address_latitude');
    const longitudeInput = document.getElementById('address_longitude');

    let coordinates;

    const areaCoordinates = {
      'Bella Vista': [-79.526022, 8.983972],
      'Ancón': [-79.549556, 8.959927],
      'Calidonia': [-79.535817, 8.968804],
      'Amelia Denis de Icaza': [-79.5128063,9.0411865]
    }

    // Method that update the value of latitude and longitude hidden inputs
    const updateCoordinates = () => {
      latitudeInput.value = marker.getLngLat().lat;
      longitudeInput.value = marker.getLngLat().lng;
    }


    mapboxgl.accessToken = createAddressMap.dataset.mapboxApiKey;
    const map = new mapboxgl.Map({
      container: 'create-address-map',
      center: [-79.528142, 8.975448], // by default showing Panama
      zoom: 15,
      style: 'mapbox://styles/mapbox/streets-v10'
    });

    // Create a new draggable market on the map, and put it in the coordinates
    const marker = new mapboxgl.Marker({
      draggable: true
    })
    .setLngLat([-79.528142, 8.975448])
    .addTo(map);

    // Every time the marker is dragged, call updateCoordinates method
    marker.on('dragend', updateCoordinates);

    addressAreas.forEach((addressArea) => {
      addressArea.addEventListener('change', event => {
        if (mapDiv.classList.contains('display-none')) {
          mapDiv.classList.remove('display-none');
        }
        coordinates = areaCoordinates[addressArea.value]
        marker.setLngLat(coordinates);
        map.resize();
        map.flyTo({ center: coordinates });
      });
    });


    if (createAddressMap.dataset.lng && createAddressMap.dataset.lat) {
      coordinates = [createAddressMap.dataset.lng, createAddressMap.dataset.lat]
      generateMap(coordinates);
    } else if (currentArea) {
      mapDiv.classList.remove('display-none');
      coordinates = areaCoordinates[currentArea]
      marker.setLngLat(coordinates);
      map.flyTo({ center: coordinates });
      setTimeout(() => {
        map.resize();
      }, 1000)
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
          zoom: 14
        });

        new mapboxgl.Marker()
          .setLngLat([ showAddressMap.dataset.lng, showAddressMap.dataset.lat ])
          .addTo(map);
      }, 500);
    };
  }

};

export { initMapbox };
