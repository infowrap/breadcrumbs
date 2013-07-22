
###

Example usage

    $(".infowrap-breadcrumbs").infowrapBreadcrumbs()

currently no options available

###

(($) ->

  $.fn.infowrapBreadcrumbs = (options) ->


    breadcrumbsObj = this

    options = $.extend {}, $.fn.infowrapBreadcrumbs.defaultOptions, options

    crumbPadding = options.crumbPadding
    minCrumbWidth = options.minCrumbWidth
    crumbShaderWidth = options.crumbShaderWidth
    crumbShaderShadowDistance = options.crumbShaderShadowDistance

    a = 1
    crumbsWidth = 0
    crumbWidths = []
    crumbWidthsCombined = []
    crumbWidthsCombined[0] = 0

    breadcrumbsObj.find(".crumb").each ->
      crumbWidth = $(this).width()
      crumbWidthTotal = crumbWidth + crumbPadding * 2
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

      crumbObj = breadcrumbsObj.find ".crumb:nth-child(#{currentCrumb})"

      if currentCrumb > totalCrumbs
        nextCrumbObj = breadcrumbsObj.find ".crumb:nth-child(#{currentCrumb+1})"
      else nextCrumbObj = null

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
        if nextCrumbObj # does this crumb even exist?
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

    # maintain chainability

    #return this.each ->
    #  new $.fn.infowrapBreadcrumbs $(this), options

  $.fn.infowrapBreadcrumbs.defaultOptions =

    # the padding on both sides of the crumb title
    crumbPadding: 15

    # the minimum width of a crumb when collapsed.
    # must be greater than or equal to 2 * padding
    minCrumbWidth: 30

    # width of the shader block that is hidden in pixels.
    # it is in the crumb object, but is pushed far right and hidden by the crumb's `overflow: hidden`
    crumbShaderWidth: 44

    # the distance of your css shadow antumbra in pixels
    crumbShaderShadowDistance: 20

) jQuery
