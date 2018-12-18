#!/bin/bash
SWIFT_LINT=swiftlint

command -v $SWIFT_LINT > /dev/null 2>&1 || { echo >&2 "Swiftlint is not installed...."; exit 1; }

FILES=$( git diff --cached --diff-filter=d --name-only | grep ".swift$" ) 

if [ $? -eq 1 ]; then
    echo "No Staged Files Found for Linting";
    exit 0 ;
fi

${SWIFT_LINT} autocorrect --quiet -- $FILES
${SWIFT_LINT} lint --quiet --strict $FILES
RESULT=$?
git add .
echo "Swiftlint exited with status $RESULT"
exit $RESULT