#!/bin/sh -l
set -e

REPORT_FILE="results.sarif"
if [ ! -z "$INPUT_REPORT_FILE" ]; then
    REPORT_FILE="$INPUT_REPORT_FILE"
fi

ROOT=$PWD
if [ ! -z "$INPUT_WORKING_DIR" ]; then
    cd "$INPUT_WORKING_DIR"
fi

if test -f "composer.json"; then
    COMPOSER_COMMAND="composer install --no-scripts --no-progress --ignore-platform-req=ext-zip --ignore-platform-req=ext-exif"
    echo "::group::$COMPOSER_COMMAND"
    $COMPOSER_COMMAND
    echo "::endgroup::"
else 
    echo "composer.json not found in repo, skipping Composer installation"
fi

/composer/vendor/bin/psalm --version
/composer/vendor/bin/psalm --output-format=github --taint-analysis --report=$REPORT_FILE $*

echo "sarif file saved to $PWD/$REPORT_FILE"

cd $ROOT
