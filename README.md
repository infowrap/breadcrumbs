# breadcrumbs

An easy way to expand or collapse menu items, especially when there are many levels like in folder navigation.

## To use

Add jQuery and then ..

    $(window).load(function() {
      $(".infowrap-breadcrumbs").infowrapBreadcrumbs();
    });


## Examples

[Screen recording on YouTube](https://www.youtube.com/watch?v=CVHiKA06XHU) (0:12)

Expanded
![](https://raw.github.com/infowrap/breadcrumbs/master/README/expanded.png)

Collapsed
![](https://raw.github.com/infowrap/breadcrumbs/master/README/collapsed.png)


## Build

To install and build, run ..

    sh install.sh
    # after the first time you can simply run `grunt`


To watch and compile specific files, run ..

    # to watch all and compile all
    grunt devAll

    # to watch and compile coffee files
    grunt devCoffee

    # to watch and compile jade files
    grunt devJade

    # to watch and compile less files
    grunt devLess


To build-only specific file types, run ..

    # to watch all and compile all
    grunt build

    # to compile coffee files
    grunt buildCoffee

    # to compile jade files
    grunt buildJade

    # to compile less files
    grunt buildLess
