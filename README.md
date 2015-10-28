JATS for Reuse
==============

This repository holds the source files for the [JATS for 
Reuse home page](http://jats4r.org/), excluding the validator.


Web site development
--------------------

Our web site is served from [jats4r.org](http://jats4r.org).

It uses the [Jekyll](http://jekyllrb.com/) static site generator; see the GitHub help page,
[Using Jekyll with Pages](https://help.github.com/articles/using-jekyll-with-pages/), for
more information about how to set this up on your machine.

The site also includes the validator, which is hosted in its [own
repository](http://github.com/jats4r/validator). That repo is set up as a Git
submodule of this one.

So, to work on the website, make sure you clone this repository with `--recursive`.
For example:

    git clone --recursive https://github.com/JATS4R/website.git

Then, to set up the validator,
follow these [setup instructions](https://github.com/jats4r/validator#quick-start).
(Skip the step about cloning the validator repository itself).

When you have all the prerequisites installed, from the *website* directory,
start a local server with:

    jekyll serve

and then access it from [http://localhost:4000](http://localhost:4000).

To test a deployment of all of the generated files, configure Apache (or
some other HTTP server) to serve the _site subdirectory of this repo, 
and then run

    ./deploy.sh --baseurl /path/to/_site

Where "/path/to/_site" is the HTTP server's path to the _site subdirectory.

For example, if you are working in ~/jats4r/website, and your HTTP server
is configured to serve that directory from http://localhost/work/jats4r/website,
then you would run

    ./deploy.sh --baseurl /work/jats4r/website/_site

You could also set the JATS4R_DOCROOT environment variable to specify a
different destination directory, to which the static site will be written.

For reference, there are three ways to view the site, and not everything
works in all cases:

* HTTP direct to the development directory (e.g.
  http://localhost:8080/work/jats4r/website). Note that generated pages 
  (e.g. topics.html) will not be available; but everything else should
  work.
* Through the Jekyll server (e.g. http://localhost:4000)
* HTTP to a deployed directory.


Conventions
-----------

Here are a few conventions we've established for our content pages.

* British spelling everywhere.
* Try to avoid using "DTD" to refer to a particular version of JATS. Use
  "schema" instead.
* When you need to distinguish between one of the tag sets; i.e. Publishing
  vs. Archiving, if needed, don't say "flavour" or "colour". Instead, try to
  refer to the name, or to the colour explicitly.


Credits
-------

The website was initially forked and modified from 
<https://github.com/cfpb/eRegulations>, which is 
[available](http://www.webcitation.org/6UKqwz9zs) under 
[CC0 1.0 Universal](http://creativecommons.org/publicdomain/zero/1.0/).

