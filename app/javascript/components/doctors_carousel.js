const doctorsCarousel = () => {

  // Select the node that will be observed for mutations
  const slides = document.querySelectorAll('#hp-carousel-doctor .carousel-item');
  const doctorProfiles = document.querySelectorAll(`.hp-carousel-doctor-profile`);
  // let doctorsProfiles = document.querySelector('.hp-carousel-doctors-grid .hp-carousel-doctor-profile[data-slideId="1"]');

  $('#hp-carousel-doctor').on('slid.bs.carousel', function () {
  // do something...
    slides.forEach(slide => {
      if (slide.classList.contains('active')) {
        const targetId = slide.dataset.slideId;
        doctorProfiles.forEach(profile => {
          if (profile.dataset.slideId == targetId) {
            profile.children[1].classList.add('active');
          } else {
            profile.children[1].classList.remove('active');
          }
        })
      }
    })
  })


}



export { doctorsCarousel };
