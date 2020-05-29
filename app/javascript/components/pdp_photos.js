const pdpPhotos = () => {
  const pdpContainer = document.querySelector('.pdp-container');
  if (pdpContainer) {

    // boostrap jquery method to stop carousel autoplay
    $('#pdp-carousel').carousel('pause');

    const colors = document.querySelectorAll('.pdp .colors input');
    const carouselItems = document.querySelectorAll('.pdp #pdp-carousel .carousel-inner div');
    colors.forEach((color) => {
      color.addEventListener('click', event => {
        carouselItems.forEach((carouselItem) => {
          console.log(carouselItem.dataset.color)
          if (carouselItem.dataset.color === color.value) {
            carouselItem.classList.remove('display-none');
            carouselItem.classList.add('carousel-item');
            if (carouselItem.dataset.order === '1') {
              carouselItem.classList.add('active');
            }
          } else {
            carouselItem.classList.remove('active');
            carouselItem.classList.remove('carousel-item');
            carouselItem.classList.add('display-none');
          }
        });
      });
    })

  }
}

export { pdpPhotos };
