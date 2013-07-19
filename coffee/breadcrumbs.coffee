
$(window).load ->

  crumbPadding = 15 # padding on both sides of the name
  crumbsWidth = 0 #
  a = 1
  crumbWidthsCombined = []
  crumbWidthsCombined[0] = 0
  crumbWidths = []
  minCrumbWidth = 30 # might not take effect as 2xPadding is more than this
  crumbShaderWidth = 44
  crumbShaderShadowDistance = 20

  breadcrumbsObj = $(".breadcrumbs")

  breadcrumbsObj.find(".crumb").each ->
    crumbWidth = $(this).width()
    crumbWidthTotal = crumbWidth + crumbPadding * 2 # + a * 22
    crumbWidths[a] = crumbWidthTotal
    crumbsWidth += crumbWidthTotal
    crumbWidthsCombined[a] = crumbsWidth
    a++

  totalCrumbs = a - 1;

  updateCrumb = (currentCrumb) ->
    totalRestOfTheCrumbs = 0
    totalCombinedCrumbCurrent = 0
    breadcrumbsWidth = breadcrumbsObj.width()

    totalCombinedCrumbCurrent = 0

    for i in [1..currentCrumb-1] by 1
      totalCombinedCrumbCurrent += crumbWidths[i]

    for i in [currentCrumb+1..crumbWidths.length-1] by 1
      totalRestOfTheCrumbs += crumbWidths[i]

    totalBeforeCurrentCrumb = (minCrumbWidth) * (currentCrumb-1)
    currentCrumbWidth = breadcrumbsWidth - totalBeforeCurrentCrumb - totalRestOfTheCrumbs
    crumbWidthsCombinedInstance = crumbWidthsCombined[crumbWidthsCombined.length - 1] - totalCombinedCrumbCurrent + (minCrumbWidth * (currentCrumb-1)) + (1 * (currentCrumb))
    crumbInstance =  crumbWidthsCombined[crumbWidthsCombined.length - 1] + totalCombinedCrumbCurrent - (minCrumbWidth * (currentCrumb-1))
    crumbObj = breadcrumbsObj.find ".crumb::nth-child(#{currentCrumb})"
    nextCrumbObj = breadcrumbsObj.find ".crumb::nth-child(#{currentCrumb+1})"
    crumbShaderObj = crumbObj.find ".shader"
    diff = crumbInstance - breadcrumbsWidth
    crumbWidth = breadcrumbsWidth - totalRestOfTheCrumbs
    if crumbWidth < minCrumbWidth then crumbWidth = minCrumbWidth

    if breadcrumbsWidth < totalBeforeCurrentCrumb + crumbWidths[currentCrumb] + totalRestOfTheCrumbs
      crumbObj.width currentCrumbWidth
      shaderPositionRight = (-crumbShaderWidth - crumbShaderShadowDistance) + (crumbWidths[currentCrumb] - currentCrumbWidth)
      if shaderPositionRight > 0 then shaderPositionRight = 0
      if Math.abs(shaderPositionRight) < crumbShaderWidth then shaderPositionRight = -crumbShaderWidth
      crumbShaderObj.css "right", shaderPositionRight
      # if the crumb above me is shrinking and i'm not fully collapsed, crap! i gotta get skinny NOW !
      if crumbWidths[currentCrumb+1] # does this crumb even exist?
        if crumbWidths[currentCrumb+1] > nextCrumbObj.outerWidth() then crumbObj.width minCrumbWidth
    else
      crumbObj.width crumbWidths[currentCrumb]
      crumbShaderObj.css "right", -crumbShaderWidth + -crumbShaderShadowDistance

  windowResize = ->
    winWidth = $(window).width()
    updateCrumb crumb for crumb in [1..totalCrumbs] by 1

  uncollapseAll = ->
    breadcrumbsObj.find(".crumb").each ->
      $(this).attr "data-crumb", "expand"

  $(window).resize -> windowResize()


  windowResize()
  windowResize()
  windowResize()
  windowResize()
  windowResize()
  windowResize()
  windowResize()
  windowResize()
  windowResize()
  windowResize()
  windowResize()
  windowResize()

