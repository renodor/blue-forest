const pdpPhotos = () => {
  const pdpContainer = document.querySelector('.pdp-container');
  if (pdpContainer) {
    // boostrap jquery method to stop carousel autoplay
    $('#pdp-carousel').carousel('pause');

    // select all colors
    const colors = document.querySelectorAll('.pdp .colors input');

    // select the default checked color (which is the main one)
    const checkedColor = document.querySelector('.pdp .colors input:checked');

    // select all carousel items
    const carouselItems = document.querySelectorAll('.pdp #pdp-carousel .carousel-inner div');

    // method that enable slides regarding what color is selected, and disable the others
    // (and put the first slide as 'active')
    const photoToggle = (targetColor) => {
      carouselItems.forEach((carouselItem) => {
        if (carouselItem.dataset.color === targetColor.value) {
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
    };

    // call the photoToggle method by default when page load on the checked color
    // (the checked color when page load is the main color)
    photoToggle(checkedColor);

    // each time a color is clicked, call the photoToggle method on this color
    colors.forEach((color) => {
      color.addEventListener('click', (event) => {
        photoToggle(color);
      });
    });
  }
};

export {pdpPhotos};
