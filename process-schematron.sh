
# Sanity check

if [ "x$SAXON_JAR" = "x" ] || ! [ -e $SAXON_JAR ]
  then
    echo "Error: SAXON_JAR doesn't point to anything. Did you remember to run '. setup.sh'?"
    exit 2
fi

# Check usage

if [ $# -ne 1 ]
   then
   echo "Usage: ./process-schematron.sh <schematron>"
    echo " "
    echo "This tool will build a combined Schematron file from a multiple-
file Schematron, validate it, and output an XSLT2 stylesheet
to run against an XML instance."
   exit 2
fi

echo Build single schematron from multiple files

java -jar $SAXON_JAR -xsl:combine-schematron.xsl -s:$1 -o:combined.sch

if [ $? -eq 0 ]
  then
    echo $1 Successfully combined into combined.sch
  else
    echo $1 Error: failed to combine schematron
    exit 2
fi


echo Validate the schema

java com.thaiopensource.relaxng.util.Driver lib/isoSchematron.rng combined.sch

if [ $? -eq 0 ]
  then
    echo $1 is valid
  else
    echo Error: $1 is an Invalid Schematron file 
    exit 2
fi

echo Generate the stylesheet from $1

java -jar $SAXON_JAR -s:combined.sch -xsl:$SCHEMATRON/iso_svrl_for_xslt2.xsl \
     -o:$1.xsl generate-paths=yes

if [ $? -ne 0 ]
  then
    echo Error: Failed to translate Schematron into XSLT
    exit 2
fi

#rm combined.sch

