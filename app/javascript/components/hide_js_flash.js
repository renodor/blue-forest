// to deal with AJAX flash messages we created a custom js flash element
// this hideJsFlash method is to make the 'close' btn of this js flash element working
const hideJsFlash = () => {
  const jsFlash = document.querySelector('.js-flash');
  const closeJsFlash = document.querySelector('.close-js-flash');

  if (jsFlash) {
    closeJsFlash.addEventListener('click', (event) => jsFlash.classList.add('display-none'));
  }
};

export {hideJsFlash};
