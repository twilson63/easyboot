# easyboot

A command line app that pulls the latest version of twitter bootstrap
and extracts the production files into a css, js, img folder.

# why

To make it simple to add the twitter bootstrap to any public project folder.

# requirements

[nodejs](http://nodejs.org)

# install

`npm install easyboot -g`

# usage

Go to your web application asset folder. (ie. public)

Then run `easyboot`

``` sh
easyboot
```

You should see the following output:

``` sh
Download Complete
Extract Complete
```

Next if your review your directory, you should see the following:

* bootstrap.zip
* /css/bootstrap.min.css
* /css/bootstrap-responsive.min.css
* /js/bootstrap.min.js
* /img/glyphicons-halflings-white.png
* /img/glyphicons-halflings.png

# license

see LICENSE

# contributions

pull requests welcome


