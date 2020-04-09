# DOM Report

Firefox 72 has 804 window properties.

What are these? When were they introduced? Are they universal?

## Analysis

We can get reliable, first hand information directly from User Agent:

||Firefox|
|--- |--- |
|ContactManager|19-24|


We can plot data. Like globals count rising (Firefox):

|version|count|
|--- |--- |
|15|67|
|16|72|
|17|72|
|18|65|
|19|582|
|20|580|
|21|570|
|22|584|
|23|577|
|24|575|
|25|526|
|...|...|
|57|768|
|58|765|
|59|756|
|60|756|


And so much more! But first we need data.

## Report

This can be easily achieved automatically by targeting User Agent to page containing

    window.onload = function () {
      event.preventDefault()
      var names = Object.getOwnPropertyNames(window)
      var xhr = new XMLHttpRequest
      xhr.open('POST', '/feature')
      xhr.setRequestHeader('Content-Type', 'application/json')
      xhr.send(JSON.stringify(names))
    }

And storing it on backend as `(useragent, feature, result)`.

## Status

Initial analysis completed on [Browsershots](http://browsershots.org/). UI is perfect for my needs. Looks like data requires cleanup and I definitely need much more.
