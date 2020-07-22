import mapboxgl from 'mapbox-gl';

const initMapbox = () => {
  const mapDiv = document.querySelector('.map');
  const createAddressMap = document.getElementById('create-address-map');
  const showAddressMap = document.getElementById('show-address-map');
  if (mapDiv) {
    const addressAreas = document.querySelectorAll('.address_area .areas');
    const currentArea = document.querySelector('.shipping-container').dataset.area;

    // Get latitude and longitude hidden inputs
    const latitudeInput = document.getElementById('address_latitude');
    const longitudeInput = document.getElementById('address_longitude');

    // manually define coordinates of panama areas (mapbox doesn't find it...)
    const areaCoordinates = {
      '24 de Diciembre': [-79.360813, 9.099316],
      'Alcalde Diaz': [-79.558165, 9.114019],
      'Ancón': [-79.549556, 8.959927],
      'Betania': [-79.526553, 9.012151],
      'Bella Vista': [-79.526022, 8.983972],
      'Calidonia': [-79.535817, 8.968804],
      'Chilibre': [-79.618491, 9.159972],
      'Curundú': [-79.543629, 8.969860],
      'El Chorrillo': [-79.543442, 8.950293],
      'Ernesto Córdova Campos': [-79.5495714, 9.1007977],
      'Juan Diaz': [-79.4589348, 9.036498],
      'Las Cumbres': [-79.541515, 9.080642],
      'Las Mañanitas': [-79.403837, 9.085597],
      'Pacora': [-79.3129942, 9.0883206],
      'Parque Lefevre': [-79.491183, 9.011381],
      'Pedregal': [-79.428246, 9.070960],
      'Pueblo Nuevo': [-79.513834, 9.008878],
      'Rio Abajo': [-79.491915, 9.024213],
      'San Felipe': [-79.535048, 8.952410],
      'San Francisco': [-79.507848, 8.992609],
      'San Martin': [-79.5561179, 9.111234],
      'Santa Ana': [-79.540677, 8.956486],
      'Tocumen': [-79.388304, 9.071253],
      'Amelia Denis de Icaza': [-79.5128063, 9.0411865],
      'Arnulfo Arias': [-79.482514, 9.065796],
      'Belisario Frías': [-79.490858, 9.074975],
      'Belisario Porras': [-79.498926, 9.053881],
      'Jose Domingo Espinar': [-79.478842, 9.046348],
      'Mateo Iturralde': [-79.496242, 9.033294],
      'Omar Torrijos': [-79.516361, 9.065943],
      'Rufina Alfaro': [-79.453506, 9.065768],
      'Victoriano Lorenzo': [-79.506351, 9.030720],
    };

    let coordinates;

    // Method that update the value of latitude and longitude hidden inputs
    const updateCoordinates = () => {
      latitudeInput.value = marker.getLngLat().lat;
      longitudeInput.value = marker.getLngLat().lng;
    };

    // initialize a mapbox map in the center of Panama
    mapboxgl.accessToken = createAddressMap.dataset.mapboxApiKey;
    const map = new mapboxgl.Map({
      container: 'create-address-map',
      center: [-79.528142, 8.975448], // by default showing Panama
      zoom: 15,
      style: 'mapbox://styles/mapbox/streets-v10',
    });

    // Create a new draggable market on the map, and put it by default in the center of Panama
    const marker = new mapboxgl.Marker({
      draggable: true,
    })
        .setLngLat([-79.528142, 8.975448])
        .addTo(map);

    // Every time the marker is dragged, call updateCoordinates method
    marker.on('dragend', updateCoordinates);

    // Add en event listener on the area (corregimiento) field
    // and update the map each time it changes
    addressAreas.forEach((addressArea) => {
      addressArea.addEventListener('change', (event) => {
        // if the map is not visible (first time you arrive on 'new address'), display it
        if (mapDiv.classList.contains('display-none')) {
          mapDiv.classList.remove('display-none');
        }
        // Then we need to do 3 things :
        // - put the marker on the center of the selected area
        // - resize the map
        // - put the center of the map on the selected area
        coordinates = areaCoordinates[addressArea.value];
        marker.setLngLat(coordinates);
        map.resize();
        map.flyTo({center: coordinates});
        latitudeInput.value = longitudeInput.value = null;
      });
    });

    // if user is editing an address, it already has lat and long
    // in that case we just need to update the map
    if (createAddressMap.dataset.lng && createAddressMap.dataset.lat) {
      coordinates = [createAddressMap.dataset.lng, createAddressMap.dataset.lat];
      marker.setLngLat(coordinates);
      map.resize();
      map.flyTo({center: coordinates});
    // if there are no lat and long but already a selected area,
    // it means the form has been rendered ('render new') again because it was invalid
    // in that case we also need to :
    // - resize map
    // - set new area coordinate to marker
    // - and center the map to thos coordinates
    // (we do that insidde a SetTimeout otherwise Mapbox has a small display bug...)
    } else if (currentArea) {
      mapDiv.classList.remove('display-none');
      setTimeout(() => {
        map.resize();
        coordinates = areaCoordinates[currentArea];
        marker.setLngLat(coordinates);
        map.flyTo({center: coordinates});
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
        center: [showAddressMap.dataset.lng, showAddressMap.dataset.lat],
        zoom: 15,
      });

      new mapboxgl.Marker()
          .setLngLat([showAddressMap.dataset.lng, showAddressMap.dataset.lat])
          .addTo(map);
    }, 500);
  };
};

export {initMapbox};
