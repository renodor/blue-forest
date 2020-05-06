const sizeCheckbox = () => {
  const sizes = document.querySelectorAll('.pdp .size input');
  if (sizes.length > 0) {
    const atc = document.querySelector('.pdp .atc');
    const atcOverlay = document.querySelector('.pdp .atc-overlay');

    const isOneSizeChecked = () => {
      sizes.forEach(size => {
        console.log(size.checked);
      });
    };

    isOneSizeChecked();
    // if (isOneSizeChecked() == false) {
    //   atc.disabled = true
    // }


    // sizes.forEach(size => {
    //   size.addEventListener('click', event => {
    //     if (size.checked == true) {
    //       console.log('yo')
    //       atcOverlay.style.display = 'none'
    //       atc.disabled = false;
    //     }
    //   })
    // });

    // atcOverlay.addEventListener('click', event => {
    //   if (atc.disabled == true) {
    //     console.log('hey');
    //   }
    // })

  }
}

export { sizeCheckbox };
