
$(window).load ->

  # Basic
  $(".infowrap-breadcrumbs").infowrapBreadcrumbs
    tabWidth: 500

  $(".infowrap-breadcrumbs").refresh()

  # With params
  # in this example, the css needs to have .crumbs padding be "0 22px"
  #$(".infowrap-breadcrumbs").infowrapBreadcrumbs minWidth: 44

