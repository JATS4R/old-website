JATS for Reuse
==============

This repository holds the source files for the [JATS for 
Reuse](http://jats4r.github.io/) home page, including the validation tools.


Directories and files
---------------------

The following are the main directories and files in this repository, and what
they are for.

* ***bin*** - Shell scripts and XSLT files that are used by them
* ***generated-xsl*** - This contains XSLT versions of the Schematron files. The contents
  here should not be edited directly.  See [Generating XSLTs from Schematron 
  sources](#generating-xslts-from-schematron-sources), below
* ***lib*** - Third party libraries and tools. See [Dependencies, 
  libraries](#dependencies-libraries), below.
* ***samples*** - Some sample XML files
* ***schema*** - The Schematron source files. See [Schema sources](#schema-sources),
  below.
* ***static*** - Some static resources that are used by the website.
* ***validate*** - The source code for the online client-side validator.


Web site development
--------------------

Our web site is served from [jats4r.org](http://jats4r.org). The content is 
hosted on GitHub pages, from the repository 
[jats4r.github.io](https://github.com/JATS4R/jats4r.github.io).

The [CNAME file](https://github.com/JATS4R/jats4r.github.io/blob/master/CNAME) in that 
repository controls the domain that the pages will be served from, so if you try to access it 
from jats4r.github.io, you will be redirected.

That repository also hosts all of the schematrons and the validation tools. To do development on 
it, and see your results before you commit and push, the best way is to use 
[Jekyll](http://jekyllrb.com/). Assuming you have that installed, start a local server with

    jekyll serve

and then access it from [http://localhost:4000](http://localhost:4000).

Alternatively, if you don't need the Markdown preprocessing, and other features (for example, if 
you're just working on the home page, the schematrons or the validator) you can serve 
your local clone of that repo from a plain HTTP server, and access it through that. For example, 
let's say you have an Apache instance running on port 8080. Clone the 
repository under the *htdocs* folder of that server, and access it through
[http://localhost:8080/jats4r.github.io](http://localhost:8080/jats4r.github.io).


Validation Setup
----------------

*The instructions on this page assume you'll be working in a *bash* shell.*

Whenever you open a new shell, to configure your environment, you must first 
source the *setup.sh* script, from this repository's root directory:

```
cd *repo dir*
source bin/setup.sh
```

The very first time you run the script, it will extract several third party
libraries, which are included in the *lib* subdirectory (see 
[Dependencies (libraries)](#dependencies-libraries), below, for a list).

Every time you run it (including the first), the script
sets various environment variables so that the libraries can be easily used.


Validating a JATS file
----------------------

To validate a JATS file named sample.xml, use the script *validate.sh*. For example,

```
validate.sh samples/minimal.xml
```

This will give a report for compliance of 
the input file *minimal.xml* with respect to all topics (*math* and *permissions*).
By default, it only reports *errors*. If you want a full report (*info*, *warnings*,
and *errors*) then enter:

```
validate.sh samples/minimal.xml info
```

Use the `-h` switch to get a list of all the possible arguments.

If your setup requires an OASIS catalog file to resolve the DTDs for JATS
documents, you can use the environment variable JATS_CATALOG to point to that.

For example, you can download the [JATS Bundle](http://jatspan.org/jats-bundle.html)
to get all of the DTDs for several versions and flavors of JATS (up to NISO
JATS draft version 0.4), and unzip it, and then set the JATS_CATALOG environment
variable to point to the master catalog from that:

```
cd ~
wget http://jatspan.org/downloads/jats-core-bundle-0.8.zip
unzip jats-core-bundle-0.8.zip
export JATS_CATALOG=~/jatspacks/catalog.xml
```

Now, when you run *validate.sh*, it will automatically use that catalog file to
resolve any DTDs.  For example:

```
validate.sh samples/sample.xml
```


Schema sources
--------------

The master schema files are in Schematron format, in the *schema* subdirectory.

The "master" Schematron file, which determines conformance or non-conformance,
is *jats4r.sch*.  This includes all topics, but only the "error level" tests.

There are two other "master" Schematron files, which break down the tests in two different
ways: one by message severity (*info*, *warnings*, and *errors*) and one by 
topic (*math* and *permissions*).

The test files themselves are broken down into separate *modules*, by topic and
by severity level.
So, for example, *permissions-errors.sch*, *permissions-warnings.sch*, and 
*permissions-info.sch* define the tests for the permissions topic. 
All three run tests on permissions, but the permissions-errors reports only those 
things that are errors. 

In summary, the master Schematron files are:

* jats4r.sch - all topics, error level only
* jats4r-level.sch - groups tests by message severity level. Using this with
  `phase=info` (or `phase=#ALL`) will run all of the tests.
* jats4r-topic.sch - groups tests by topic. So, for example, when you run this
  with the `phase=math`, you will run just the math tests. 

The *generated-xsl* subdirectory contains XSLT2 files that have been generated from 
the Schematrons, using the *process-schematron.sh* script. 
These XSLT files must not be edited directly. If a change is made to a Schematron, a 
new XSLT should be auto-generated, using the process-schematron.sh script. 

When run against an instance, they will generate a report in [Schematron Validation 
Report Language XML](http://www.schematron.com/validators.html) (SVRL).


Generating XSLTs from Schematron sources
----------------------------------------

To generate new XSLT files in the generated-xsl directory, first, as described above,
you must source the *bin/setup.sh* script into your shell.

Then, use the script *process-schematron.sh* to convert the Schematron files into XSLT:

```
./process-schematron.sh
```

You can optionally pass this script an *input-type* (`level` or `topic`) and a 
*phase* (which depends on the *input-type*). Enter `./process-schematron.sh -h` 
for usage information.

This writes the output files into the *generated-xsl* directory.



Dependencies, libraries
-----------------------

Several open-source software tools are used in this project, and, for convenience,
have been included in this repository.

As described above, the *setup.sh* script extracts these and sets various environment
variables so that they can be easily used by the tools here.


***Saxon Home Edition***

Version 9.5.1, downloaded from 
[here](http://sourceforge.net/projects/saxon/files/Saxon-HE/9.5/SaxonHE9-5-1-5J.zip)
on 2015-04-02, and included in this repository as lib/SaxonHE9-5-1-5J.zip.

***ISO Schematron schema***

This is the schema that defines what is a valid Schematron file. This 
version is from 2005, and is included here as lib/isoSchematron.rng. 

***Jing***

Release from 10/28/2008, downloaded from 
[here](http://jing-trang.googlecode.com/files/jing-20081028.zip) on 2015-04-02,
and included as lib/jing-20081028.zip.

***ISO Schematron XSLT***

Downloaded from 
[here](http://www.schematron.com/tmp/iso-schematron-xslt2.zip) on 2015-04-02,
and included as lib/iso-schematron-xslt2.zip.

***Apache Commons OASIS catalog resolver***

Downloaded from 
[here](http://apache.mirrors.pair.com//xerces/xml-commons/xml-commons-resolver-1.2.zip)
on 2015-04-02, and included as lib/xml-commons-resolver-1.2.zip.





Credits
-------

The website was initially forked and modified from 
<https://github.com/cfpb/eRegulations>, which is 
[available](http://www.webcitation.org/6UKqwz9zs) under 
[CC0 1.0 Universal](http://creativecommons.org/publicdomain/zero/1.0/).

