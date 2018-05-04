#!/bin/bash

if ! is_true "$ENABLE_PATCHES"; then
    sectionText "SKIP: applying patches is disabled"
    return 0
fi

find_sorted "${WORKDIR}/docker/patches" ".patch"
if [ -z "$FILES_SORTED" ]; then
    sectionText "SKIP: no patches found"
    return 0
fi

for p in $FILES_SORTED; do
    PATCH_FILE=`basename $p`
    sectionText "Apply patch: $PATCH_FILE"
    patch -p1 < $p
done

