/*

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
*/


/*
self-invoking anonymous wrapper, which imports jquery on last line
*/


(function() {
  ((function() {
    return function($) {
      var methods;
      methods = {
        build: function() {
          var collapsedCrumb, crumbObjs, crumbWidths, crumbsObj, expandedCrumb, infowrapBreadcrumbsObj, shaderObjs, totalCrumbs;
          infowrapBreadcrumbsObj = this;
          crumbsObj = infowrapBreadcrumbsObj.find(".crumbs");
          ({
            maxCollapsedCrumbs: 3,
            minWidth: 44,
            shaderWidth: 44,
            shaderAntumbra: 25,
            allowVariableWidths: false,
            tabWidth: 150
          });
          /*
          the nth crumb that is collapsed counting from the left, and the nth crumb
          that is expanded counting from the left. the expanded crumb is only detected
          if no collapsed crumb is found. this prevents an error when on a small
          screen and all are collapsed
          */

          collapsedCrumb = 0;
          expandedCrumb = 0;
          /*
          the total number of crumbs
          if 3, then it should be 3
          */

          totalCrumbs = 0;
          /*
          iterating thru the crumbs, this will say what the current width of each
          crumb would be if fully expanded. the crumbs width as it lies before being
          compressed
          */

          crumbWidths = [];
          /*
          store each crumb object in an object for later reference. otherwise you'll
          need to perform an expensive `find`
          */

          crumbObjs = [];
          /*
          store each crumb .shader object in an object for later reference. otherwise
          you'll need to perform an expensive `find`
          */

          shaderObjs = [];
          /*
          loop thru each crumb
          */

          return crumbsObj.find(".crumb").each(function(index, value) {
            /*
            define the crumb object as its used more than once
            */

            var crumbObj;
            crumbObj = $(this);
            /*
            cache the crumb to an objects for later use
            */

            crumbObjs[index + 1] = crumbObj;
            /*
            ensure attr is removed
            this function is called on refresh so some crumbs may have it
            */

            crumbObj.removeAttr("data-collapsed");
            crumbObj.removeAttr("style");
            /*
            add the shader div, which is a moving piece. would like to add with
            :after, but currently it cant be manipulated in jquery. triple quotes
            used so the html can be typed naturally
            */

            if (!crumbObj.find('.shader').length) {
              crumbObj.append("<div class=\"shader\"></div>");
            }
            /*
            cache the shadow of the crumb to a unique object for later use
            */

            shaderObjs[index + 1] = crumbObj.find(".shader");
            /*
            the outer width of each crumb (width and padding, margin, etc)
            */

            if (allowVariableWidths) {
              crumbWidths[index + 1] = crumbObj.outerWidth();
            } else {
              crumbWidths[index + 1] = tabWidth;
            }
            /*
            +1 to total number of crumbs
            */

            return totalCrumbs++;
          });
        },
        windowResize: function() {
          /*
          windowResize is a set of operations used in a couple of places, it has been
          added as a method to call on load and on resize. when the user resizes the
          page, run the updateCrumb method on each crumb. One is subtracted from
          totalCrumbs, because there's no need to adjust the last crumb width as the
          overflow:hidden will handle it
          */

          var crumb, _i, _ref, _results;
          _results = [];
          for (crumb = _i = 1, _ref = totalCrumbs - 1; _i <= _ref; crumb = _i += 1) {
            _results.push(updateCrumb(crumb, infowrapBreadcrumbsObj.width()));
          }
          return _results;
        },
        updateCrumb: function(crumb, breadcrumbsWidth) {
          /*
          method to run on each crumb to define its width against the other crumbs
          and against the whole breadcrumbs bar. accepts the inputs of an integer
          crumb, if referencing 2nd crumb, number is 2. breadcrumbsWidth is
          an integer of the current container width, which is parent to .crumbs
          */

          /*
          the natural width of the crumb when fully expanded. added as a variable
          for easy reference
          */

          var afterCrumb, beforeCrumb, collapsedCrumb, crumbObj, crumbWidth, crumbWidthCurrently, crumbWidthDiff, crumbsLeft, expandedCrumb, i, nextCrumbObj, nextCrumbWidth, shaderObj, shaderX, _i, _ref;
          crumbWidth = crumbWidths[crumb];
          /*
          the natural width of the next crumb when fully expanded. added as a
          variable for easy reference
          */

          nextCrumbWidth = crumbWidths[crumb + 1];
          /*
          determine how much with there is before the current crumb. this is
          calculated by adding up the number of collapsed crumbs before it as it
          assumes that every crumbe before current crumb is collapsed
          */

          beforeCrumb = 0;
          beforeCrumb = minWidth * (crumb - 1);
          /*
          determine how much with there is after the current crumb by iterating
          over all the crumbs following the currenct crumb
          */

          afterCrumb = 0;
          for (i = _i = _ref = crumb + 1; _i <= totalCrumbs; i = _i += 1) {
            afterCrumb += crumbWidths[i];
          }
          /*
          this is the magic, the current crumb width is simlpy the difference
          between the whole bar minus what is before and after the current crumb
          */

          crumbWidthDiff = breadcrumbsWidth - beforeCrumb - afterCrumb;
          /*
          set the current crumb object for easy reference
          */

          crumbObj = crumbObjs[crumb];
          crumbWidthCurrently = crumbObj.outerWidth();
          /*
          we'll be doing an extra check on the crumb after the current one. if there
          is one, lets refernce it, otherwise null it out
          */

          if (crumb > totalCrumbs) {
            nextCrumbObj = crumbObjs[crumb + 1];
          } else {
            nextCrumbObj = null;
          }
          /*
          set the current .shader object for easy reference
          */

          shaderObj = shaderObjs[crumb];
          if (crumbWidthCurrently < crumbWidth) {
            crumbObj.attr("data-expanded", false);
          } else {
            crumbObj.attr("data-expanded", true);
          }
          /*
          if the breadcrumbs width is less than what the width is before, after, and
          including the width of this crumb, then we'll need to start collapsing a
          crumb, otherwise we should make sure it's full natural width
          */

          if (breadcrumbsWidth < beforeCrumb + crumbWidth + afterCrumb) {
            /*
            set the crumb width to our new determined (by diff) width
            */

            if (allowVariableWidths) {
              crumbObj.outerWidth(crumbWidthDiff);
            } else {
              crumbObj.outerWidth(minWidth);
            }
            /*
            if the maxCollapsedCrumbs is set, then lets make it happen
            */

            if (maxCollapsedCrumbs) {
              /*
              when a crumb diff width is equal to or less than the minimum crumb
              width, then is collapsed, then flag it with a data attribute otherwise
              set it to false
              */

              if (crumbWidthDiff < minWidth) {
                crumbObj.attr("data-collapsed", true);
              } else {
                crumbObj.attr("data-collapsed", false);
              }
              /*
              look for the first instance of false, in other words the first
              uncollapsed crumb. todo: optimize this to run once
              */

              collapsedCrumb = crumbsObj.find(".crumb[data-collapsed=\"false\"]:first").index();
              if (collapsedCrumb < 0) {
                collapsedCrumb = totalCrumbs - 1;
                expandedCrumb = crumbsObj.find(".crumb[data-collapsed=\"true\"]:first").index();
              }
              /*
              if the collapsed crumb index is greater than or equal to the
              maxCollapsedCrumbs option, then there are too many crumbs visible,
              and the .crumbs container needs to go left and be hidden by the
              overflow:hidden of the parent, .infowrap-breadcrumbs. the crumbs
              can go too far right, because of the loose if conditional, so a
              protection maxes out at 0
              */

              if (collapsedCrumb >= maxCollapsedCrumbs || expandedCrumb >= 0) {
                crumbsLeft = -minWidth * (collapsedCrumb - maxCollapsedCrumbs);
                if (crumbsLeft > 0) {
                  crumbsLeft = 0;
                }
                crumbsObj.css("left", crumbsLeft);
              }
            }
            /*
            the shader moves with the window resize to simulate a growing overlap
            as the objects get tighter.
            */

            shaderX = -shaderWidth - shaderAntumbra + crumbWidth - crumbWidthDiff;
            /*
            the div that creates the shadow should not enter the visible space, it
            should always be cropped out of view by overflow:hidden
            */

            if (shaderX > -shaderWidth) {
              shaderX = -shaderWidth;
            }
            /*
            set the shader x position off the right with position absolute
            */

            shaderObj.css("right", shaderX);
            /*
            if the next crumb is shrinking and the current crumb is not fully
            collapsed, then the user is doing a quick move and we need to do a fast
            override to keep up
            */

            /*
            does the crumb exist?
            */

            if (nextCrumbObj) {
              /*
              if the natural width of the next crumb is greater than the next crumbs
              current width, then the crumb outer width should be the minimum crumb
              width as per the plugin options
              */

              if (nextCrumbWidth > nextCrumbObj.outerWidth()) {
                return crumbObj.outerWidth(minWidth);
              }
            }
          } else {
            /*
            set the crumb to be full width
            */

            crumbObj.outerWidth(crumbWidth);
            /*
            reset the shadow to its intended starting position at right per the
            plugin options
            */

            return shaderObj.css("right", -shaderWidth - shaderAntumbra);
          }
        },
        init: function() {
          /*
          data binding and dom updates
          this reinitializes the crumbs to ensure accuracy
          */

          this.build();
          this.windowResize();
          /*
          run the above method on every fire of window resize
          */

          $(window).resize(function() {
            return this.windowResize();
          });
          return console.log("init");
        },
        refresh: function() {
          /*
          data binding and dom updates
          this reinitializes the crumbs to ensure accuracy
          */

          this.build();
          return this.windowResize();
        },
        test: function() {
          return console.log("hi");
        }
      };
      /*
      declaring the jQery plugin
      */

      return $.fn.infowrapBreadcrumbs = function(methodOrOptions) {
        if (methods[methodOrOptions]) {
          return methods[methodOrOptions].apply(this, Array.prototype.slice.call(arguments, 1));
        } else if (typeof methodOrOptions === 'object' || !methodOrOptions) {
          return methods.init.apply(this, arguments);
        } else {
          return $.error('Method ' + methodOrOptions + ' does not exist');
        }
      };
    };
    /*
    import jquery into the self-invoking anonymous wrapper
    */

  })())(jQuery);

}).call(this);
