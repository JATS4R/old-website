# Sanity check - are we in the right place?

if ! [ -e process-schematron.sh ]
  then
    echo Error: you must run this script from within the validation repository.
    exit 2
fi

# If the saxon he jar doesn't exist, then we know we need to unzip everything

export SAXON_JAR=`pwd`/lib/saxon9he/saxon9he.jar
if ! [ -e $SAXON_JAR ] 
  then
    echo Extracting libraries
    cd lib
    unzip -d saxon9he SaxonHE9-5-1-5J.zip
    unzip jing-20081028.zip
    unzip -d iso-schematron-xslt2 iso-schematron-xslt2.zip
    unzip xml-commons-resolver-1.2.zip
    cd ..
fi

export JING_HOME=`pwd`/lib/jing-20081028
export JING_BIN=$JING_HOME/bin
export SCHEMATRON=`pwd`/lib/iso-schematron-xslt2
export RESOLVER_JAR=`pwd`/lib/xml-commons-resolver-1.2/resolver.jar

CLASSPATH=$SAXON_JAR
CLASSPATH=$CLASSPATH:$JING_BIN/isorelax.jar
CLASSPATH=$CLASSPATH:$JING_BIN/jing.jar
CLASSPATH=$CLASSPATH:$JING_BIN/xercesImpl.jar
CLASSPATH=$CLASSPATH:$JING_BIN/xml-apis.jar
CLASSPATH=$CLASSPATH:$RESOLVER_JAR

export CLASSPATH
