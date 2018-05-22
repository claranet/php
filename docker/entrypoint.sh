#!/bin/bash

cd $WORKDIR

# include all .inc.sh files, so consumers are able to provide their own functions
for i in $WORKDIR/docker/*.inc.sh; do
  source $i
done

get_sections # defines $SECTIONS
case $1 in
    build)
      # special exit: print last lines of the build log
      # if exit != 0
      trap build_exit EXIT
      ;;
    --help|help|-h)
      shift
      help $*
      exit 0
      ;;
esac

set -e

if is_in_list "$1" "$SECTIONS"; then

  SECTION="$1"
  if [ -z "$2" ]; then
    run_section "$1"
  else
    SUBSECTION="$2"
    get_subsections
    shift; shift # drop section and subsection from args
    SUBSECTION_ARGS="$*"
    run_subsection
  fi

else
  warnText "Unknown section $1, passing it to sh -c ..."
  sh -c "$*"
fi


