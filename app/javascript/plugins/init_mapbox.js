import mapboxgl from 'mapbox-gl';

const initMapbox = () => {
  const createAddressMap = document.getElementById('create-address-map');
  const showAddressMap = document.getElementById('show-address-map');

  // Interactive map when creating addresses
  if (createAddressMap) {
    mapboxgl.accessToken = createAddressMap.dataset.mapboxApiKey;
    const map = new mapboxgl.Map({
      container: 'create-address-map',
      center: [-79.5254181, 9.0152974], // by default showing Panama
      zoom: 10,
      style: 'mapbox://styles/mapbox/streets-v10'
    });

    // Get latitude and longitude hidden inputs
    const latitudeInput = document.getElementById('address_latitude');
    const longitudeInput = document.getElementById('address_longitude');

    // Create a new draggable market on the map, and put it by default in Panama
    const marker = new mapboxgl.Marker({
      draggable: true
    })
    .setLngLat([-79.5254181, 9.0152974])
    .addTo(map);

    // Method that update the value of latitude and longitude hidden inputs
    const updateCoordinates = () => {
      latitudeInput.value = marker.getLngLat().lat;
      longitudeInput.value = marker.getLngLat().lng;
    }

    // Every time the marker is dragged, call updateCoordinates method
    marker.on('dragend', updateCoordinates);
  };

  // Static map when showing addresse
  if (showAddressMap) {
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

    // const bounds = new mapboxgl.LngLatBounds();
    // console.log(bounds);
    // map.fitBounds([ showAddressMap.dataset.lng, showAddressMap.dataset.lat ], { padding: 70, maxZoom: 15, duration: 10 })
    // map.fitBounds([
    //   [showAddressMap.dataset.lng - 15, showAddressMap.dataset.lat -15],
    //   [showAddressMap.dataset.lng -15, showAddressMap.dataset.lat -15]
    // ]);
  };
};

export { initMapbox };
