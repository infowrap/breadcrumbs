(function() {
  $(window).load(function() {
    $(".infowrap-breadcrumbs").infowrapBreadcrumbs({
      tabWidth: 500
    });
    return $(".infowrap-breadcrumbs").refresh();
  });

}).call(this);
