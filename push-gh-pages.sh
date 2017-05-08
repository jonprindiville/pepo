#!/bin/bash -x
#
# push-gh-pages.sh
#
# What?
# - helps update https://jonprindiville.github.io/pepo/ by pushing new
#   index.html to the gh-pages branch
#
# How?
# - develop develop develop, commit, push new pepo.elm to master branch
# - ./push-gh-pages.sh
# - was there a new "Autoupdate" commit created in gh-pages branch?
#   - yes? push it, now it's published
#   - no? maybe you didn't actually change stuff, or elm-make barfed, or your
#     network connection flaked, or ...

TMP_DIR="$(mktemp -d)";
TMP_INDEX="$TMP_DIR/index.html";

elm-make pepo.elm && \
    mv index.html "$TMP_INDEX" && \
    git checkout gh-pages && \
    mv "$TMP_INDEX" . && \
    git add index.html && \
    git commit -m "Autoupdate index.html for gh-pages" && \
    rmdir "$TMP_DIR";
