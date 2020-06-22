// method to open/close the sidebar cart
const mobileMenu = () => {
  const navbarTogglers = document.querySelectorAll('.navbar-toggler');
  const navbarCollapse = document.querySelector('.navbar-collapse');
  const navbarDropdowns = document.querySelectorAll('.navbar-collapse .dropdown-menu')

  // listen clicks on the navbar toggle and open the navbar when clicked
  navbarTogglers.forEach((navbarToggler) => {
      navbarToggler.addEventListener('click', () => {
      navbarCollapse.classList.toggle('active');
    });
  });

  // on small device, show dropdown menus by default
  if (window.innerWidth < 576) {
    navbarDropdowns.forEach((navbarDropdown) => {
      navbarDropdown.classList.add('show');
    });
  }

  // if the windows is resized, check if we need to show dropdown menus by default or not
  window.addEventListener('resize', event => {
    if (window.innerWidth < 576) {
      navbarDropdowns.forEach((navbarDropdown) => {
        navbarDropdown.classList.add('show');
      });
    } else {
      navbarDropdowns.forEach((navbarDropdown) => {
        navbarDropdown.classList.remove('show');
      });
    }
  })
}

export { mobileMenu };
