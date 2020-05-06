const sidebarCart = () => {
  const cart = document.getElementById('sidebar-cart')
  const cartToggle = document.querySelectorAll('.cart-toggle')

  cartToggle.forEach(toggle => {
    toggle.addEventListener('click', event => {
      cart.classList.toggle('active');
    })
  });
}

export { sidebarCart };
