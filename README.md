validation
==========

Source code for validation

The Schematron files are here. All of the tests are broken out into individual .sch files that are called into the main Schematron file(s). 

These individual test files are written into the modules directory. The tests are grouped together by Topic and error level. For example, we have permissions-errors.sch, permissions-warnings.sch, and permissions-info.sch. All three run tests on permissions, but the permissions-errors reports only those things that are errors. 


jats4r-errlevel-0.sch:
----------------------
The tests can be run with jats4r-errlevel-0.sch (which calls in all of the modules). They are grouped in the main Schematron file by level of reporting. When you run jats4r-errlevel-0.sch with the phase=errors, you will only run the error tests. This would give us a pass/fail for the article. 

When you run the jats4r-errlevel-0.sch with the phase=warnings, you will run the error and the warning tests, and when you run it with phase=info (or phase=#ALL) you will run all of the tests. The default phase is set to "errors", so if you just run it, it will act as a strict validator. 


jats4r-topic-0.sch:
----------------------
The tests can also be with jats4r-topic-0.sch (which calls in all of the modules). They are grouped in the main Schematron file by topic (math and permissions for now). When you run jats4r-topic-0.sch with the phase=permissions, you will only run the permissions tests.  

When you run the jats4r-topic-0.sch with the phase=math, you will run the math tests.There is no default phase. If you run it with phase=#ALL or no phase, it should run all of htests. When run this way, it will give the same result as  jats4r-errlevel-0.sch run with phase=info or #ALL.


generated-xsl/
----------------------
This directory contains XSL2 files that have been generated from the Schematrons in this "validation" directory. These XSL files must not be edited directly. If a change is made to a Schematron, a new XSL should be created. 

When run against an instance, they will generate a report in Schematron Validation Report Language XML (svrl; http://www.schematron.com/validators.html)

These were created for users who may have trouble applying Schematron directly in their system. They were created using iso-svrl.xsl.


## Dependencies (lib)

Several open-source software tools are used in this project.

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




## Getting Saxon

Download and extract the open-source Saxon Home Edition, which is written in Java, and will work on most platforms. You can download it from [here](http://sourceforge.net/projects/saxon/files/Saxon-HE/). Navigate to the latest version, and follow the instructions (which appear after the list of files). As a shortcut, you can download version 9.5 (which is known to work with these XSLTs) from the command line directly:

    wget http://sourceforge.net/projects/saxon/files/Saxon-HE/9.5/SaxonHE9-5-1-5J.zip

Unzip that into some subdirectory of your choosing. For example (on a unix-like operating system):

    unzip -d ~/saxon9he SaxonHE9-5-1-5J.zip

Set an environment variable SAXON_JAR to point to the executable Jar file. For example:

    export SAXON_JAR=~/saxon9he/saxon9he.jar

If your version of Saxon is in a different location, then, of course, set this environment variable appropriately.

On Windows, for example, depending on the location you unzipped it to:

    set SAXON_JAR=C:\bin\saxon9he\saxon9he.jar

## Getting the ISO Schematron implementation

You'll need to download iso-schematron-xslt2.zip from [this Schematron page](http://www.schematron.com/implementation.html), and extract it to some 
directory of your choosing. Then, set the environment variable SVRL_XSLT to point to the iso_svrl_for_xslt2.xsl file within 
that directory. For example:

    wget http://www.schematron.com/tmp/iso-schematron-xslt2.zip
    unzip -d ~/iso-schematron-xslt2 iso-schematron-xslt2.zip
    export SVRL_XSLT=~/iso-schematron-xslt2/iso_svrl_for_xslt2.xsl

## Preparing schematron XSLTs

Now, you should be able to convert the Schematron files here into XSLTs, 
which are used to do the actual validation.  For example, for unix-like operating
systems:

    java -jar $SAXON_JAR -o:jats4r-errlevel-0.xsl -s:jats4r-errlevel-0.sch $SVRL_XSLT

Or, for Windows:

    java -jar %SAXON_JAR% -o:jats4r-errlevel-0.xsl -s:jats4r-errlevel-0.sch %SVRL_XSLT%

## Getting the catalog resolver

Depending on whether or not your JATS files use DTDs, and how those are specified, 
you might need to install the [Apache OASIS catalog 
resolver](http://projects.apache.org/projects/xml_commons_resolver.html) library, which you can
get from [their download page](http://xerces.apache.org/mirrors.cgi). At the time of this writing,
the resolver can be downloaded from 
[http://apache.mirrors.pair.com//xerces/xml-commons/xml-commons-resolver-1.2.zip]().

Download that, extract it, and then set the RESOLVER environment variable to point to it:

    wget http://apache.mirrors.pair.com//xerces/xml-commons/xml-commons-resolver-1.2.zip
    unzip -d ~/xml-commons-resolver-1.2 xml-commons-resolver-1.2.zip
    export RESOLVER=~/xml-commons-resolver-1.2/resolver.jar


## Validating a JATS file

For validation, we'll run Saxon, but now, since we are using external jar file libraries
(the catalog resolver) we can't use the `-jar` shortcut. Instead, specify the location of
Saxon as well as the library in the CLASSPATH.  On unix-like operating systems:

    export CLASSPATH=$SAXON_JAR:$RESOLVER

Or, on Windows:

    export CLASSPATH=%SAXON_JAR%;%RESOLVER%

Finally, to validate a JATS file named sample.xml, enter the following (Unix and Windows are the same):

    java net.sf.saxon.Transform -catalog:../../klortho/jatspan/jatspacks/catalog.xml -s:sample.xml -xsl:jats4r-errlevel-0.xsl -o:report.xml
