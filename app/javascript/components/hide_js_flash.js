const hideJsFlash = () => {
  const jsFlash = document.querySelector('.js-flash');
  const closeJsFlash = document.querySelector('.close-js-flash');

  if (jsFlash) {
   closeJsFlash.addEventListener('click', event => jsFlash.classList.add('display-none'));
  }
}

export { hideJsFlash };
