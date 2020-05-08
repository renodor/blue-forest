import mapboxgl from 'mapbox-gl';

const initMapbox = () => {
  const createAddressMap = document.getElementById('create-address-map');
  const showAddressMap = document.getElementById('show-address-map');

  // Interactive map when creating addresses
  if (createMap) {
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
    const map = new mapboxgl.Map({
      container: 'map',
      center: [-79.5254181, 9.0152974],
      zoom: 11,
      style: 'mapbox://styles/mapbox/streets-v10'
    });

    const latitudeInput = document.getElementById('address_latitude');
    const longitudeInput = document.getElementById('address_longitude');

    const marker = new mapboxgl.Marker({
      draggable: true
    })
    .setLngLat([-79.5254181, 9.0152974])
    .addTo(map);

    const updateCoordinates = () => {
      latitudeInput.value = marker.getLngLat().lat;
      longitudeInput.value = marker.getLngLat().lng;
    }

    marker.on('dragend', updateCoordinates);
  };

  // Static map when showing addresse
  if (showAddressMap) {
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
    const map = new mapboxgl.Map({
      container: 'map',
      center: [-79.5254181, 9.0152974],
      zoom: 11,
      style: 'mapbox://styles/mapbox/streets-v10'
    });

      const markers = JSON.parse(mapElement.dataset.markers);
      markers.forEach((marker) => {
        new mapboxgl.Marker()
          .setLngLat([ marker.lng, marker.lat ])
          .addTo(map);
      });
  };
};

export { initMapbox };
