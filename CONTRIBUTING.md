
# Introduction

We welcome contributions a lot! You can contribute by telling us what you think will be of benefit for the project. Tell us your
ideas! In addition, we welcome PRs and are happy improve this project further and further.

By ourselves, we don't have all the time required to make this project shiny; but we are willing to contribute as much as we can.
Therefor it helps us, if you read this, hopfully short, overview how contribution to this project normaly work.


# How to contribute via PRs

## Dependencies

* we are using [bump2version](https://github.com/c4urself/bump2version) to manage version bumping

## Flow

If you created a PR, please be patient with us. We will come for a review ASAP!

This is how it normally goes:

1. fork this project
  * please make sure indentation matches the style used in the corresponding file
  * please track you changes in the `CHANGELOG.md`
  * you are allowed to do many unfance commits until this PR is in its final state
1. you create a PR
1. someone from the maintainers will review the PR
1. if there are any things to discuss about, those things need to be sorted out
1. we check if squashing / rebasing is required to clean up history and enable a fast-forward merge with master
1. we will ask to fill the if missing CHANGELOG and after that to bump the version via bump2version
1. PR gets merged
1. we will tag a new release following semver

