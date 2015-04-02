validation
==========

Source code for validation

The Schematron files are here. All of the tests are broken out into individual .sch files that are included into the main Schematron file(s). 

These individual test files are written into the modules directory. The tests are grouped together by topic and error level. For example, we have permissions-errors.sch, permissions-warnings.sch, and permissions-info.sch. All three run tests on permissions, but the permissions-errors reports only those things that are errors. 


jats4r-level-0.sch:
-------------------

The tests can be run with jats4r-level-0.sch (which calls in all of the modules). They are grouped in the main Schematron file by level of reporting. When you run jats4r-level-0.sch with the phase=errors, you will only run the error tests. This would give us a pass/fail for the article. 

When you run the jats4r-level-0.sch with the phase=warnings, you will run all of the error and the warning tests, and when you run it with phase=info (or phase=#ALL) you will run all of the tests. The default phase is set to "errors", so if you just run it, it will act as a strict validator. 


jats4r-topic-0.sch:
----------------------

The tests can also be with jats4r-topic-0.sch (which calls in all of the modules). They are grouped in the main Schematron file by topic (math and permissions for now). When you run jats4r-topic-0.sch with the phase=permissions, you will only run the permissions tests.  

When you run the jats4r-topic-0.sch with the phase=math, you will run the math tests. There is no default phase. If you run it with phase=#ALL or no phase, it should run all of htests. When run this way, it will give the same result as  jats4r-errlevel-0.sch run with phase=info or #ALL.


generated-xsl/
--------------

This directory contains XSLT2 files that have been generated from the Schematrons in this "validation" directory. These XSLT files must not be edited directly. If a change is made to a Schematron, a new XSLT should be auto-generated, using the process-schematron.sh script. 

When run against an instance, they will generate a report in [Schematron Validation Report Language XML](http://www.schematron.com/validators.html) (SVRL).

These were created for users who may have trouble applying Schematron directly in their system.


Generating XSLTs from Schematron sources
========================================

To generate new XSLT files in the generated-xsl directory, first you must source the *setup.sh* script into your shell (these instructions all assume you are using a ***bash*** shell). Whenever you start up a new terminal window, change directory to the repository working directory, and then:

```
source setup.sh
```

The first time you run this, it will extract several libraries Zip archives in the *lib* subdirectory, and set a number of needed environment variables. Subsequently, it will skip the library extraction step, and just set the environment variables.

Then, use the script ./process-schematron.sh to convert the Schematron files into XSLT:

```
./process-schematron.sh
```

You can optionally pass this script an *input-type* (`level` or `topic`) and a *phase* (which depends on the *input-type*). Enter `./process-schematron.sh -h` for usage information.

This writes the output files into the *generated-xsl* directory.


Validating a JATS file
======================

Finally, to validate a JATS file named sample.xml, enter the following:

```
java net.sf.saxon.Transform -s:sample.xml \
    -xsl:jats4r-errlevel-0.xsl -o:report.xml
```

[FIXME: describe how to use the -catalog option above to include an OASIS catalog file.]



Dependencies (libraries)
========================

Several open-source software tools are used in this project, and, for convenience,
have been included in this repository.

The *setup.sh* script extracts these, and sets various environment variables
so that they can be easily used. In any terminal window, change to the respository
directory, and source this setup script before doing any work. For example,

```
cd *repo dir*
. setup.sh
```

***Saxon Home Edition***

Downloaded from 
http://sourceforge.net/projects/saxon/files/Saxon-HE/9.5/SaxonHE9-5-1-5J.zip
on 4/2/2015, and included in this repository as lib/SaxonHE9-5-1-5J.zip.

***ISO Schematron schema***

This is the schema that defines what is a valid Schematron file. This 
version is from 2005, and is included here as lib/isoSchematron.rng. 

***Jing***

Release from 10/28/2008, downloaded from 
[here](http://jing-trang.googlecode.com/files/jing-20081028.zip) on 4/2/2015,
and included as lib/jing-20081028.zip.

***ISO Schematron XSLT***

Downloaded from http://www.schematron.com/tmp/iso-schematron-xslt2.zip on 4/2/2015,
and included as lib/iso-schematron-xslt2.zip.

***Apache Commons OASIS catalog resolver***

Downloaded from 
http://apache.mirrors.pair.com//xerces/xml-commons/xml-commons-resolver-1.2.zip
on 4/2/2015, and included as lib/xml-commons-resolver-1.2.zip.

