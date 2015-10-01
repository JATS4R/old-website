#!/bin/bash

# Copy all the needed validator files into the website. This assumes the validator
# repository was cloned into a sibling directory.

echo "==> Copying the validator"
rsync --archive --quiet \
  --exclude='venv' \
  --exclude='.git' \
  --exclude='jats/src' \
  --exclude='lib/DtdAnalyzer-0.5' \
  --exclude='lib/iso-schematron-xslt2' \
  --exclude='lib/jing-20081028' \
  --exclude='lib/xml-commons-resolver-1.2' \
  ../validator .

echo "==> Done"
