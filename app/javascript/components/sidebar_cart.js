// method to open/close the sidebar cart
const sidebarCart = () => {
  const body = document.querySelector('body');
  const cart = document.getElementById('sidebar-cart');
  const openSidebarCart = document.querySelector('.open-sidebar-cart');
  const closeSidebarCart = document.querySelector('.close-sidebar-cart');
  let clickCount = 0;

  // helper method that hide the sidebar when clicked anywhere on the body
  // (except on the cart)
  // the clickCount is needed in order to hide it only after the 2nd click
  // (because one 1st click is counted when we click on the cart toggle to open it)
  const bodyClickable = () => {
    clickCount += 1;
    if (clickCount > 1) {
      cart.classList.remove('active');
      clickCount = 0;
      body.removeEventListener('click', bodyClickable);
    }
  };


  // listen clicks on the cart toggle of the navbar, and open sidebar cart when clicked
  openSidebarCart.addEventListener('click', () => {
    cart.classList.add('active');
    // when sidebar cart is open, we need to listen click on the body
    // (except on the sidebar cart itself)
    // so that if the body is clicked, the sidebar cart is closed
    body.addEventListener('click', bodyClickable);
    // stoping propagation on the sidebar cart remove it from the click event listener
    // (so that when you click on the body it close it, but not on the cart itself)
    cart.addEventListener('click', (event) => {
      event.stopPropagation();
    });
  });

  // listen clicks on the closing sidebar cart button
  closeSidebarCart.addEventListener('click', () => {
    // when clicked, hide the sidebar cart but also remove the event listener on the body
    // and put the clickCount to 0 again (for next time)
    cart.classList.remove('active');
    body.removeEventListener('click', bodyClickable);
    clickCount = 0;
  });
};

export {sidebarCart};
