import mapboxgl from 'mapbox-gl';

const initMapbox = () => {

  const mapDiv = document.querySelector('.map');
  if (mapDiv) {

    const createAddressMap = document.getElementById('create-address-map');
    const showAddressMap = document.getElementById('show-address-map');
    const addressDistrict = document.getElementById('address_district');
    const addressArea = document.getElementById('address_area');

    // Get latitude and longitude hidden inputs
    const latitudeInput = document.getElementById('address_latitude');
    const longitudeInput = document.getElementById('address_longitude');
    const areaCoordinates = {
      'Bella Vista': [-79.526022, 8.983972],
      'Ancón': [-79.549556, 8.959927],
      'Calidonia': [-79.535817, 8.968804]
    }

    // Method that update the value of latitude and longitude hidden inputs
    const updateCoordinates = () => {
      latitudeInput.value = marker.getLngLat().lat;
      longitudeInput.value = marker.getLngLat().lng;
    }

    const generateMap = (coordinates) => {
      mapboxgl.accessToken = createAddressMap.dataset.mapboxApiKey;
      const map = new mapboxgl.Map({
        container: 'create-address-map',
        center: coordinates, // by default showing Panama
        zoom: 15,
        style: 'mapbox://styles/mapbox/streets-v10'
      });

      // Create a new draggable market on the map, and put it in the coordinates
      const marker = new mapboxgl.Marker({
        draggable: true
      })
      .setLngLat(coordinates)
      .addTo(map);

      // Every time the marker is dragged, call updateCoordinates method
      marker.on('dragend', updateCoordinates);
    }

    if (createAddressMap.dataset.lng && createAddressMap.dataset.lat) {
      coordinates = [createAddressMap.dataset.lng, createAddressMap.dataset.lat]
      generateMap(coordinates);
    }

    addressArea.addEventListener('change', event => {
      mapDiv.style.display = 'block';
      let coordinates;
      if (addressArea.value) {
        coordinates = areaCoordinates[addressArea.value]
      } else {
        coordinates = [-79.5254181, 9.0152974]
      }
      generateMap(coordinates);
    })


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
