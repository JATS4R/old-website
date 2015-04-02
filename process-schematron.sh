
# Sanity check

if [ "x$SAXON_JAR" = "x" ] || ! [ -e $SAXON_JAR ]
  then
    echo "Error: SAXON_JAR doesn't point to anything. Did you remember to run '. setup.sh'?"
    exit 2
fi

## Check usage
#
#if [ $# -ne 1 ]
#   then
#   echo "Usage: ./process-schematron.sh <schematron>"
#    echo " "
#    echo "This tool will build a combined Schematron file from a multiple-
#file Schematron, validate it, and output an XSLT2 stylesheet
#to run against an XML instance."
#   exit 2
#fi

OUTPUT_DIR=generated-xsl


for IN in jats4r-errlevel-0 jats4r-topic-0
do
  IN_SCH=$IN.sch

  echo Build single schematron from multiple files

  COMBINED_SCH=$IN-combined.sch
  java -jar $SAXON_JAR -xsl:combine-schematron.xsl -s:$IN_SCH -o:$COMBINED_SCH

  if [ $? -eq 0 ]
    then
      echo $1 Successfully combined $IN_SCH into $COMBINED_SCH
    else
      echo $1 Error: failed to combine $IN_SCH
      exit 2
  fi


  echo Validate the schema

  java com.thaiopensource.relaxng.util.Driver lib/isoSchematron.rng $COMBINED_SCH

  if [ $? -eq 0 ]
    then
      echo $IN_SCH is valid
    else
      echo Error: $IN_SCH is an invalid Schematron file 
      exit 2
  fi

  echo Generate the stylesheet

  OUT_XSL=$OUTPUT_DIR/$IN.xsl
  java -jar $SAXON_JAR -s:$COMBINED_SCH -xsl:$SCHEMATRON/iso_svrl_for_xslt2.xsl \
       -o:$OUT_XSL generate-paths=yes

  if [ $? -ne 0 ]
    then
      echo Error: Failed to translate Schematron $IN_SCH into XSLT $OUT_XSL
      exit 2
    else
      echo Successfully generated $OUT_XSL
  fi


  rm $COMBINED_SCH

done
