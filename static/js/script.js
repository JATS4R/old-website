
function set_scrollto_handlers() {
  console.log("starting scrollTop is: html: " + $('html').scrollTop() +
              ", body: " + $('body').scrollTop());

  // animated scroll_to. Returns false if the target was found, true otherwise
  function scroll_to(frag) {
    var target = $(frag);
    target = target.length ? target : $('[name=' + frag.slice(1) +']');
    if (target.length) {
      $('html,body').animate({
        scrollTop: target.offset().top - 80
      }, 500);

      if (frag.match(/^#re[cm]\d+\b/)) {
        target.closest('li')
          .css('background-color', '#FFFFA0')
          .animate({backgroundColor: 'white'}, 3000);
      }

      return false;
    }
    return true;
  }

  // On document load, do scroll_to to make sure the target is not obscured 
  // by the header
  if (location.hash != '') {
    setTimeout(function() { 
      console.log("After a second, scrollTop is: html: " + $('html').scrollTop() +
              ", body: " + $('body').scrollTop());
      scroll_to(location.hash); }, 100);
  }

  // Set click handler on matching hyperlinks
  $('a[href*=#]:not([href=#])').click(function() {
    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') || 
        location.hostname == this.hostname) 
    {
      return scroll_to(this.hash);
    }
  });
}

$(document).ready(set_scrollto_handlers);


