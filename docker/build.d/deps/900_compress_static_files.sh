#!/bin/bash

if [ -z "$COMPRESS_FILE_PATHS" ]; then
    sectionText "SKIP: no compress file paths set"
    return 0
fi

compress_files() {
    local directory="$1"
    sectionText "Compress files matching $COMPRESS_FILE_MATCH in $directory"
    find $directory -regextype posix-extended -regex "$COMPRESS_FILE_MATCH" -type f -exec gzip -9 --keep {} + &>> $BUILD_LOG
}

for i in $COMPRESS_FILE_PATHS; do
    compress_files $i
done
