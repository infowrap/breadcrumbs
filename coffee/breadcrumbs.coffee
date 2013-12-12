
###

Example usage

  $(".infowrap-breadcrumbs").infowrapBreadcrumbs()

  optional settings passed in as an object
  see descriptions below in defaultOptions
  options =
    minWidth: 30
    shaderWidth: 44
    shaderAntumbra: 20
  $(".infowrap-breadcrumbs").infowrapBreadcrumbs(options)

  you can also refresh the crumbs when the DOM dynamically updates
  $(".infowrap-breadcrumbs").infowrapBreadcrumbs('refresh')

some text pulled from http://msdn.microsoft.com/en-us/magazine/ff608209.aspx

###

###
self-invoking anonymous wrapper, which imports jquery on last line
###
(($) ->

  ###
  declaring the jQery plugin
  ###
  $.fn.infowrapBreadcrumbs = (options) ->
    ###
    save this as a variable so it isn't lost or confused with another this
    ###
    infowrapBreadcrumbsObj = this

    ###
    cache the .crumbs to an object for later use
    ###
    crumbsObj = infowrapBreadcrumbsObj.find ".crumbs"

    ###
    allowing formal options overrides to be respected

    now that we have defined your default values, we can manually override them
    by manipulating them outside the jquery plugin. these changes to the default
    values will be implemented on all subsequent uses of the jquery plugin.

    if i want to override one of the default values used for future instances of
    a plugin, i would write code like the following:

    $.fn.infowrapBreadcrumbs.defaultOptions.minWidth = 50;
    $('#helloWorld').infowrapBreadcrumbs();
    $('#goodbyeWorld').infowrapBreadcrumbs();
    ###
    bcOptions = $.extend {}, $.fn.infowrapBreadcrumbs.defaultOptions, options

    ###
    globalizing the variables for the method, so if we have to make a change to
    the varable on its way in, we have a place to address that potential
    ###
    maxCollapsedCrumbs = bcOptions.maxCollapsedCrumbs - 1
    minWidth = bcOptions.minWidth
    shaderWidth = bcOptions.shaderWidth
    shaderAntumbra = bcOptions.shaderAntumbra
    allowVariableWidths = bcOptions.allowVariableWidths
    tabWidth = bcOptions.tabWidth
    collapsedCrumb = expandedCrumb = totalCrumbs = 0
    crumbWidths = crumbObjs = shaderObjs = []

    initCrumbs = () ->
      ###
      the nth crumb that is collapsed counting from the left, and the nth crumb
      that is expanded counting from the left. the expanded crumb is only detected
      if no collapsed crumb is found. this prevents an error when on a small
      screen and all are collapsed
      ###
      collapsedCrumb = 0
      expandedCrumb = 0

      ###
      the total number of crumbs
      if 3, then it should be 3
      ###
      totalCrumbs = 0

      ###
      iterating thru the crumbs, this will say what the current width of each
      crumb would be if fully expanded. the crumbs width as it lies before being
      compressed
      ###
      crumbWidths = []

      ###
      store each crumb object in an object for later reference. otherwise you'll
      need to perform an expensive `find`
      ###
      crumbObjs = []

      ###
      store each crumb .shader object in an object for later reference. otherwise
      you'll need to perform an expensive `find`
      ###
      shaderObjs = []

      ###
      loop thru each crumb
      ###
      crumbsObj.find(".crumb").each (index, value) ->

        ###
        define the crumb object as its used more than once
        ###
        crumbObj = $ this

        ###
        cache the crumb to an objects for later use
        ###
        crumbObjs[index + 1] = crumbObj

        ###
        ensure attr is removed
        this function is called on refresh so some crumbs may have it
        ###
        crumbObj.removeAttr "data-collapsed"
        crumbObj.removeAttr "style"

        ###
        add the shader div, which is a moving piece. would like to add with
        :after, but currently it cant be manipulated in jquery. triple quotes
        used so the html can be typed naturally
        ###
        unless crumbObj.find('.shader').length
          # only append if not already added
          crumbObj.append """<div class="shader"></div>"""

        ###
        cache the shadow of the crumb to a unique object for later use
        ###
        shaderObjs[index + 1] = crumbObj.find ".shader"

        ###
        the outer width of each crumb (width and padding, margin, etc)
        ###
        if allowVariableWidths
          crumbWidths[index + 1] = crumbObj.outerWidth()
        else
          crumbWidths[index + 1] = tabWidth
        ###
        +1 to total number of crumbs
        ###
        totalCrumbs++

    ###
    windowResize is a set of operations used in a couple of places, it has been
    added as a method to call on load and on resize. when the user resizes the
    page, run the updateCrumb method on each crumb. One is subtracted from
    totalCrumbs, because there's no need to adjust the last crumb width as the
    overflow:hidden will handle it
    ###
    windowResize = ->
      for crumb in [1 .. totalCrumbs - 1] by 1
        updateCrumb crumb, infowrapBreadcrumbsObj.width()

    ###
    method to run on each crumb to define its width against the other crumbs
    and against the whole breadcrumbs bar. accepts the inputs of an integer
    crumb, if referencing 2nd crumb, number is 2. breadcrumbsWidth is
    an integer of the current container width, which is parent to .crumbs
    ###
    updateCrumb = (crumb, breadcrumbsWidth) ->

      ###
      the natural width of the crumb when fully expanded. added as a variable
      for easy reference
      ###
      crumbWidth = crumbWidths[crumb]

      ###
      the natural width of the next crumb when fully expanded. added as a
      variable for easy reference
      ###
      nextCrumbWidth = crumbWidths[crumb + 1]

      ###
      determine how much with there is before the current crumb. this is
      calculated by adding up the number of collapsed crumbs before it as it
      assumes that every crumbe before current crumb is collapsed
      ###
      beforeCrumb = 0
      beforeCrumb = minWidth * (crumb - 1)

      ###
      determine how much with there is after the current crumb by iterating
      over all the crumbs following the currenct crumb
      ###
      afterCrumb = 0
      afterCrumb += crumbWidths[i] for i in [crumb + 1 .. totalCrumbs] by 1

      ###
      this is the magic, the current crumb width is simlpy the difference
      between the whole bar minus what is before and after the current crumb
      ###
      crumbWidthDiff = breadcrumbsWidth - beforeCrumb - afterCrumb

      ###
      set the current crumb object for easy reference
      ###
      crumbObj = crumbObjs[crumb]


      crumbWidthCurrently = crumbObj.outerWidth()

      ###
      we'll be doing an extra check on the crumb after the current one. if there
      is one, lets refernce it, otherwise null it out
      ###
      if crumb > totalCrumbs
        nextCrumbObj = crumbObjs[crumb + 1]
      else
        nextCrumbObj = null

      ###
      set the current .shader object for easy reference
      ###
      shaderObj = shaderObjs[crumb]


      if crumbWidthCurrently < crumbWidth
        crumbObj.attr "data-expanded", false
      else
        crumbObj.attr "data-expanded", true

      #if crumbWidthCurrently == minWidth
      #  crumbObj.attr "data-collapsed", true
      #else
      #  crumbObj.attr "data-collapsed", true



      ###
      if the breadcrumbs width is less than what the width is before, after, and
      including the width of this crumb, then we'll need to start collapsing a
      crumb, otherwise we should make sure it's full natural width
      ###
      if breadcrumbsWidth < beforeCrumb + crumbWidth + afterCrumb

        ###
        set the crumb width to our new determined (by diff) width
        ###
        if allowVariableWidths
          crumbObj.outerWidth crumbWidthDiff
        else
          crumbObj.outerWidth minWidth

        ###
        if the maxCollapsedCrumbs is set, then lets make it happen
        ###
        if maxCollapsedCrumbs

          ###
          when a crumb diff width is equal to or less than the minimum crumb
          width, then is collapsed, then flag it with a data attribute otherwise
          set it to false
          ###
          if crumbWidthDiff < minWidth
            crumbObj.attr "data-collapsed", true
          else
            crumbObj.attr "data-collapsed", false

          ###
          look for the first instance of false, in other words the first
          uncollapsed crumb. todo: optimize this to run once
          ###
          collapsedCrumb = crumbsObj.find(""".crumb[data-collapsed="false"]:first""").index()

          if collapsedCrumb < 0
            collapsedCrumb = totalCrumbs - 1
            expandedCrumb = crumbsObj.find(""".crumb[data-collapsed="true"]:first""").index()

          ###
          if the collapsed crumb index is greater than or equal to the
          maxCollapsedCrumbs option, then there are too many crumbs visible,
          and the .crumbs container needs to go left and be hidden by the
          overflow:hidden of the parent, .infowrap-breadcrumbs. the crumbs
          can go too far right, because of the loose if conditional, so a
          protection maxes out at 0
          ###
          if collapsedCrumb >= maxCollapsedCrumbs or expandedCrumb >= 0
            crumbsLeft = -minWidth * (collapsedCrumb - maxCollapsedCrumbs)
            if crumbsLeft > 0 then crumbsLeft = 0
            crumbsObj.css "left", crumbsLeft

        ###
        the shader moves with the window resize to simulate a growing overlap
        as the objects get tighter.
        ###
        shaderX = -shaderWidth - shaderAntumbra + crumbWidth - crumbWidthDiff

        ###
        the div that creates the shadow should not enter the visible space, it
        should always be cropped out of view by overflow:hidden
        ###
        if shaderX > -shaderWidth then shaderX = -shaderWidth

        ###
        set the shader x position off the right with position absolute
        ###
        shaderObj.css "right", shaderX

        ###
        if the next crumb is shrinking and the current crumb is not fully
        collapsed, then the user is doing a quick move and we need to do a fast
        override to keep up
        ###

        ###
        does the crumb exist?
        ###
        if nextCrumbObj

          ###
          if the natural width of the next crumb is greater than the next crumbs
          current width, then the crumb outer width should be the minimum crumb
          width as per the plugin options
          ###
          if nextCrumbWidth > nextCrumbObj.outerWidth()
            crumbObj.outerWidth minWidth
      else
        ###
        set the crumb to be full width
        ###
        crumbObj.outerWidth crumbWidth

        ###
        reset the shadow to its intended starting position at right per the
        plugin options
        ###
        shaderObj.css "right", -shaderWidth - shaderAntumbra

    if options is 'refresh'
      ###
      refresh crumbs
      data binding and dom updates
      this reinitializes the crumbs to ensure accuracy
      ###
      initCrumbs()
      windowResize()

    ###
    INITIALIZE
    ###
    initCrumbs()
    ###
    run the method after load to set the crumb widths correctly
    ###
    windowResize()

    ###
    run the above method on every fire of window resize
    ###
    $(window).resize -> windowResize()

    ###
    maintain chainability -- coming soon!

    currently not working
      Uncaught TypeError: Object [object Object] has no method 'find'

    return this.each ->
      new $.fn.infowrapBreadcrumbs $(this), options
    ###

  ###
  the default options for the plugin assigned per jquery plugin spec
  ###
  $.fn.infowrapBreadcrumbs.defaultOptions =

    ###
    the maximum number of visible collapsed crumbs counting from the left
    ###
    maxCollapsedCrumbs: 3

    ###
    the minimum width of a crumb when collapsed
    ###
    minWidth: 44

    ###
    width of the shader block that is hidden in pixels. it is in the crumb
    object, but is pushed far right and hidden by the crumb's `overflow: hidden`
    ###
    shaderWidth: 44

    ###
    the distance of your css shadow antumbra in pixels
    ###
    shaderAntumbra: 25

    ###
    allow variable widths for crumbs or only show as expanded/collapsed
    ###
    allowVariableWidths: false

    ###
    the width of a tab when expanded
    ###
    tabWidth: 150

###
import jquery into the self-invoking anonymous wrapper
###
) jQuery
