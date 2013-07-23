
###

Example usage

  $(".infowrap-breadcrumbs").infowrapBreadcrumbs()

  optional settings passed in as an object
  see descriptions below in defaultOptions
    minWidth: 30
    shaderWidth: 44
    shaderAntumbra: 20

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
    crumbsObj = this

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
    options = $.extend {}, $.fn.infowrapBreadcrumbs.defaultOptions, options

    ###
    globalizing the variables for the method, so if we have to make a change to
    the varable on its way in, we have a place to address that potential
    ###
    minWidth = options.minWidth
    shaderWidth = options.shaderWidth
    shaderAntumbra = options.shaderAntumbra

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
      crumbObj = $(this)

      ###
      cache the crumb to an object for later use
      ###
      crumbObjs[index + 1] = crumbObj

      ###
      add the shader div, which is a moving piece. would like to add with
      :after, but currently it cant be manipulated in jquery. triple quotes
      used so the html can be typed naturally
      ###
      crumbObj.append """<div class="shader"></div>"""

      ###
      cache the shadow of the crumb to a unique object for later use
      ###
      shaderObjs[index + 1] = crumbObj.find ".shader"

      ###
      the outer width of each crumb (width and padding, margin, etc)
      ###
      crumbWidths[index + 1] = crumbObj.outerWidth()

      ###
      +1 to total number of crumbs
      ###
      totalCrumbs++

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
      for i in [crumb + 1 .. totalCrumbs] by 1
        afterCrumb += crumbWidths[i]

      ###
      this is the magic, the current crumb width is simlpy the difference
      between the whole bar minus what is before and after the current crumb
      ###
      crumbWidthDiff = breadcrumbsWidth - beforeCrumb - afterCrumb

      ###
      set the current crumb object for easy reference
      ###
      crumbObj = crumbObjs[crumb]

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

      ###
      if the breadcrumbs width is less than what the width is before, after, and
      including the width of this crumb, then we'll need to start collapsing a
      crumb, otherwise we should make sure it's full natural width
      ###
      if breadcrumbsWidth < beforeCrumb + crumbWidth + afterCrumb

        ###
        set the crumb width to our new determined (by diff) width
        ###
        crumbObj.outerWidth crumbWidthDiff

        ###
        the shader moves with the window resize to simulate a growing overlap
        as the objects get tighter.
        ###
        shaderX = -shaderWidth - shaderAntumbra + crumbWidth - crumbWidthDiff

        ###
        the `right` css attribute should not be less than 0
        ###
        if shaderX > 0 then shaderX = 0

        ###
        the div that creates the shadow should not enter the visible space, it
        should always be cropped out of view by overflow:hidden
        ###
        if shaderX < shaderWidth then shaderX = -shaderWidth

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

    ###
    windowResize is a set of operations used in a couple of places, it has been
    added as a method to call on load and on resize. when the user resizes the
    page, run the updateCrumb method on each crumb
    ###
    windowResize = ->
      updateCrumb crumb, crumbsObj.width() for crumb in [1 .. totalCrumbs] by 1

    ###
    run the above method on every fire of window resize
    ###
    $(window).resize -> windowResize()

    ###
    run the method after load to set the crumb widths correctly
    ###
    windowResize()

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
    the minimum width of a crumb when collapsed
    ###
    minWidth: 30

    ###
    width of the shader block that is hidden in pixels. it is in the crumb
    object, but is pushed far right and hidden by the crumb's `overflow: hidden`
    ###
    shaderWidth: 44

    ###
    the distance of your css shadow antumbra in pixels
    ###
    shaderAntumbra: 20

###
import jquery into the self-invoking anonymous wrapper
###
) jQuery
