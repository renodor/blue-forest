const doctorsCarousel = () => {
  const doctorsCarousel = document.getElementById('hp-carousel-doctor');

  if (doctorsCarousel) {
    const slides = document.querySelectorAll('#hp-carousel-doctor .carousel-item');
    const doctorProfiles = document.querySelectorAll(`.hp-carousel-doctor-profile`);

    // show the doctor profile regarding what slide is active
    $('#hp-carousel-doctor').on('slid.bs.carousel', function() {
      slides.forEach((slide) => {
        if (slide.classList.contains('active')) {
          const targetId = slide.dataset.slideId;
          doctorProfiles.forEach((profile) => {
            if (profile.dataset.slideId == targetId) {
              profile.children[1].classList.add('active');
            } else {
              profile.children[1].classList.remove('active');
            }
          });
        }
      });
    });
  }
};

export {doctorsCarousel};
