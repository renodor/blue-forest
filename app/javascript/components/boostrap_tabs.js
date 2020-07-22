// JS to add deeplinks to user dashboard boostrap tabs
// to send people directly to profile or orders tab
// source: https://webdesign.tutsplus.com/tutorials/how-to-add-deep-linking-to-the-bootstrap-4-tabs-component--cms-31180
const boostrapTabs = () => {
  const dashboard = document.getElementById('dashboardTab');

  if (dashboard) {
    $(document).ready(() => {
      let url = location.href.replace(/\/$/, '');

      if (location.hash) {
        const hash = url.split('#');
        $('#dashboardTab a[href="#'+hash[1]+'"]').tab('show');
        url = location.href.replace(/\/#/, '#');
        history.replaceState(null, null, url);
        setTimeout(() => {
          $(window).scrollTop(0);
        }, 400);
      }

      $('a[data-toggle="tab"]').on('click', (event) => {
        let newUrl;
        const hash = $(event.currentTarget).attr('href');
        if (hash == '#profile') {
          newUrl = url.split('#')[0];
        } else {
          newUrl = url.split('#')[0] + hash;
        }
        newUrl += '/';
        history.replaceState(null, null, newUrl);
      });
    });
  }
};

export {boostrapTabs};
