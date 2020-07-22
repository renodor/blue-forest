const atcModal = () => {
  // force to trigger add to cart modal if present
  if ($('#atcModal')) {
    $('#atcModal').modal('show');
  }
};

export {atcModal};
