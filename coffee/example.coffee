
$(window).load ->

  # Basic
  $(".infowrap-breadcrumbs").infowrapBreadcrumbs
    tabWidth: 150
    minWidth: 44
    maxCollapsedCrumbs:3

  # Call refresh anytime the crumbs markup in the DOM changes dynamically
  $(".infowrap-breadcrumbs").infowrapBreadcrumbs('refresh')

