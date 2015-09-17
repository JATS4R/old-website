JATS for Reuse
==============

This repository holds the source files for the [JATS for 
Reuse home page](http://jats4r.org/), excluding the validator.




Web site development
--------------------

Our web site is served from [jats4r.org](http://jats4r.org).

The site also includes the validator, which is hosted in its [own
repository](http://github.com/jats4r/validator).

To work on the website, and see your results before it is deployed, use 
[Jekyll](http://jekyllrb.com/) and bundler. See the GitHub help page,
[Using Jekyll with Pages](https://help.github.com/articles/using-jekyll-with-pages/), for
more information about how to set this up.

Assuming you have everything installed, start a local server with

    bundle exec jekyll serve

and then access it from [http://localhost:4000](http://localhost:4000).

Alternatively, if you don't need the Markdown preprocessing, and other features (for example, if 
you're just working on the home page) you can serve 
your local clone of that repo from a plain HTTP server, and access it through that.


Conventions
-----------

Here are a few conventions we've established for our content pages.

* British spelling everywhere.
* Try to avoid using "DTD" to refer to a particular version of JATS. Use
  "schema" instead.
* When you need to distinguish between one of the tag sets; i.e. Publishing
  vs. Archiving, if needed, don't say "flavour" or "colour". Instead, try to
  refer to the name, or to the color explicitly.


Credits
-------

The website was initially forked and modified from 
<https://github.com/cfpb/eRegulations>, which is 
[available](http://www.webcitation.org/6UKqwz9zs) under 
[CC0 1.0 Universal](http://creativecommons.org/publicdomain/zero/1.0/).

