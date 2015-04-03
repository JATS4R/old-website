JATS for Reuse
==============

This repository holds the source files for the [JATS for 
Reuse](http://jats4r.github.io/) web site, including the validation tools.

The rest of this README describes the validation tools, and how to use them and
do development on them.


Web site development
--------------------

To make changes to this site, first fork the repository into your own account,
and then clone it and make a gh-pages branch. Push that back up, and you should be able
to see your own version of the site at http://username.github.io/jats4r.github.io.
For example,

```
git clone git@github.com:username/jats4r.github.io.git
cd jats4r.github.io
git checkout -b gh-pages
git push
```

When you are happy with the changes, submit them as a pull request from your gh-pages
branch to the master branch of the main repo. Or, if you have write access, and are
sure the changes are okay, you can push them directly:

```
# Do this once, to set up `jats4r` as a remote:
git remote add jats4r git@github.com:JATS4R/jats4r.github.io.git
# Push changes directly from your gh-pages branch to the main repo's master branch:
git push jats4r gh-pages:master
```


Validation Setup
----------------

The instructions on this page assume you'll be working in a *bash* shell.
Whenever you open a new shell, to configure your environment, you must first 
source the *setup.sh* script, from this repository's *validate* directory:

```
cd *repo dir*/validate
source setup.sh
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
./validate.sh sample.xml
```

This will give a report for compliance of 
the input file *sample.xml* with respect to all topics (*math* and *permissions*).
By default, it only reports *errors*. If you want a full report (*info*, *warnings*,
and *errors*) then enter:

```
./validate.sh sample.xml info
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
resolve any DTDs.


Source code
-----------

There are two master Schematron files, which break down the tests in two different
ways: one by message severity (*info*, *warnings*, and *errors*) and one by 
topic (*math* and *permissions*).

The test files themselves are in the *modules* subdirectory. 
So, for example, *permissions-errors.sch*, *permissions-warnings.sch*, and 
*permissions-info.sch* define the tests for the permissions topic. 
All three run tests on permissions, but the permissions-errors reports only those 
things that are errors. 

The master Schematron files are:

* jats4r-level-0.sch - groups tests by message severity level. Using this with
  `phase=info` (or `phase=#ALL`) will run all of the tests.
* jats4r-topic-0.sch - groups tests by topic. So, for example, when you run the 
  jats4r-topic-0.sch with the `phase=math`, you will run just the math tests. 

The *generated-xsl* subdirectory contains XSLT2 files that have been generated from 
the Schematrons, using the *process-schematron.sh* script. 
These XSLT files must not be edited directly. If a change is made to a Schematron, a 
new XSLT should be auto-generated, using the process-schematron.sh script. 

When run against an instance, they will generate a report in [Schematron Validation 
Report Language XML](http://www.schematron.com/validators.html) (SVRL).


Generating XSLTs from Schematron sources
----------------------------------------

To generate new XSLT files in the generated-xsl directory, first, as described above,
you must source the *setup.sh* script into your shell.

Then, use the script ./process-schematron.sh to convert the Schematron files into XSLT:

```
./process-schematron.sh
```

You can optionally pass this script an *input-type* (`level` or `topic`) and a 
*phase* (which depends on the *input-type*). Enter `./process-schematron.sh -h` 
for usage information.

This writes the output files into the *generated-xsl* directory.



Dependencies (libraries)
------------------------

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

