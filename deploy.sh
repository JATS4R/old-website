#!/bin/bash

# This script deploys the current contents of the website and validator repositories.
# Set the $JATS4R_DOCROOT to the destination that you want. It defaults to ./_site.
# It assumes that validator is cloned as a sister of this website repo.

DOCROOT=${JATS4R_DOCROOT:-./_site}
echo "==> Deploying to $DOCROOT"

echo "==> Building the static site with jekyll"
jekyll build --destination=$DOCROOT

echo "==> Copying the validator"
rsync --archive --quiet --exclude='.git' ../validator $DOCROOT

echo "==> Done"
