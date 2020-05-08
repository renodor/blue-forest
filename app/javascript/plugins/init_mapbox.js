import mapboxgl from 'mapbox-gl';

const initMapbox = () => {
  const mapElement = document.getElementById('map');

  if (mapElement) { // only build a map if there's a div#map to inject into
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
      console.log(marker.getLngLat());
      latitudeInput.value = marker.getLngLat().lat;
      longitudeInput.value = marker.getLngLat().lng;
    }

    marker.on('dragend', updateCoordinates);
  };
};

export { initMapbox };
