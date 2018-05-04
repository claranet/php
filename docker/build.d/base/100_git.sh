#!/bin/sh

# configures git to use https instead of git+ssh for github.com sources
sectionText "Use https instead SSH for git clone/fetch"
git config --global url."https://github.com/".insteadOf "git@github.com:"
git config --global url.https://.insteadOf git://
