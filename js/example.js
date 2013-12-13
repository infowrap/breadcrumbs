(function() {
  $(window).load(function() {
    $(".infowrap-breadcrumbs").infowrapBreadcrumbs({
      tabWidth: 150,
      minWidth: 44,
      maxCollapsedCrumbs: 3
    });
    return $(".infowrap-breadcrumbs").infowrapBreadcrumbs('refresh');
  });

}).call(this);
