#!/bin/bash

# This script deploys the current contents of the website and validator repositories.
# Set the $JATS4R_DOCROOT to the destination that you want. It defaults to ./_site.

# You can set a baseurl on the command line, for development deployments.
# It defaults to the empty string (which is the value for production), which 
# means that generated URLs (for scripts and such) will be based on the root 
# of the web site. 
# For development, you could set, for example (no trailing slash):
#     --baseurl=/cfm/web/git/jats4r/website/_site
# and URLs will be based there.

USAGE='Usage: ./deploy.sh [--help] [--baseurl <baseurl>]'
DOCROOT=${JATS4R_DOCROOT:-./_site}
BASEURL=""

# Parse command line options
while [ $# -gt 0 ]
do
    case "$1" in
        --help)
            echo >&2 $USAGE
            exit 1;;
        --baseurl) 
            shift
            BASEURL=$1;;
    esac
    shift
done

# If BASEURL is not empty, write the config line to config_baseurl.yml,
# and set CONFIG_OPT

CONFIG_OPT=""
if ! [ "$BASEURL" = "" ]; then
    echo 'baseurl: "'$BASEURL'"' > config_baseurl.yml
    CONFIG_OPT='--config _config.yml,config_baseurl.yml'
fi

echo "==> Deploying to $DOCROOT; using BASEURL '$BASEURL'"
jekyll build --destination=$DOCROOT $CONFIG_OPT
echo "==> Done"
