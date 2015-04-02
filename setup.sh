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
fi

