
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

  java -jar $SAXON_JAR -xsl:combine-schematron.xsl \
    -s:$1 -o:combined.sch

if [ $? -eq 0 ]
  then
    echo $1 successfully combined into combined.sch
  else
    echo $1 failed to combine schematron
    exit 2
fi


echo Validate the schema

  java com.thaiopensource.relaxng.util.Driver \
    isoSchematron.rng combined.sch

if [ $? -eq 0 ]
  then
    echo $1 is valid
  else
    echo $1 is an Invalid Schematron file 
    exit 2
fi


if [ -z "$2" ]
    then 
        p=""
    else
        p="phase=$2"
fi

echo Generate the stylesheet from $1

  java -jar $SAXON_JAR -s:combined.sch -xsl:iso_svrl.xsl -o:$1.xsl \
    generate-paths=yes $p

#rm combined.sch

