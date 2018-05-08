#!/bin/sh
set -e -o pipefail
export TERM=xterm

#get amount of available prozessors * 2 for faster compiling of sources
COMPILE_JOBS=$((`getconf _NPROCESSORS_ONLN`*2))

ERROR_BKG='\e[41m' # background red
GREEN_BKG='\e[42m' # background green
BLUE_BKG='\e[44m' # background blue
YELLOW_BKG='\e[43m' # background yellow
MAGENTA_BKG='\e[45m' # background magenta

INFO_TEXT='\033[33' # yellow text
WHITE_TEXT='\033[97m' # text white
BLACK_TEXT='\033[30' # text black
RED_TEXT='\033[31' # text red
MAGENTA_TEXT='\033[35m'
NC='\033[0m' # reset

# this is a state file
APT_CACHE_REFRESHED="/var/tmp/apt-cache-refreshed"


debugHead() {
  echo -e "${WHITE_TEXT}${MAGENTA_BKG}$*${NC}\n"
  echo -e "$*\n" >> $BUILD_LOG
}

debugText() {
  echo -e "${MAGENTA_TEXT}$*${NC}\n"
  echo -e "$*\n" >> $BUILD_LOG
}

warnText() {
  echo -e "\n${BLACK_TEXT}${YELLOW_BKG}*** ${1} ***${NC}\n"
  echo -e "\n*** $1 ***\n" >> $BUILD_LOG
}

errorText() {
  echo -e "\n${WHITE_TEXT}${ERROR_BKG}!!! ${1} !!!${NC}\n"
  echo -e "\n!!! $1 !!!\n" >> $BUILD_LOG
}

successText() {
  echo -e "\n${BLACK_TEXT}${GREEN_BKG}=> ${1} <=${NC}\n"
  echo -e "SUCCESS: $1" >> $BUILD_LOG
}

chapterHead() {
  echo -e "\n${BLUE_BKG}${WHITE_TEXT}::: ${1} :::${NC}\n"
  echo -e "\n::: $1 :::\n" >> $BUILD_LOG
}

sectionHead() {
  echo -e "\n${INFO_TEXT}m===> ${1} <===${NC}"
  echo -e "\n==> $1" >> $BUILD_LOG
}

sectionText() {
  echo -e "${INFO_TEXT}m-> ${1}${NC}"
  echo -e "-> $1" >> $BUILD_LOG
}

remove_recursive() {
  eatmydata rm -rvf $* &>> $BUILD_LOG
}

cleanup_docker_image() {
  if ! is_true $ENABLE_CLEANUP; then
    warnText "SKIP: Do not publish this image, since it might contain sensitive data due to ENABLE_CLEANUP has been disabled"
    return 0
  fi

  if [ -e '/var/tmp/build-deps.list' ]; then
    sectionText "APT: remove build packages and caches"
    local pkg_list=`tr '\n' ' ' < /var/tmp/build-deps.list`
    if [ ! -z "$pkg_list" ]; then
      eatmydata apt-get purge -y -qq $pkg_list &>> $BUILD_LOG
      rm /var/tmp/build-deps.list
    fi
  fi

  eatmydata apt-get autoremove -y &>> $BUILD_LOG
  remove_recursive /var/lib/apt/lists/*
  remove_recursive $APT_CACHE_REFRESHED

  sectionText "NPM: remove node_modules and package.json files"
  remove_recursive `find $WORKDIR -type d -name 'node_modules'`
  remove_recursive /root/.npm $WORKDIR/node_modules $npm_tmp_files
  
  sectionText "COMPOSER: remove package caches and composer.json files"
  eatmydata composer clear-cache &>>$BUILD_LOG
  remove_recursive $WORKDIR/package.json $WORKDIR/package.lock /root/.composer /usr/bin/composer.phar
  
  sectionText "TMP: cleanup /tmp folder"
  remove_recursive /tmp/*
  
  if [ -e "$HOME/.netrc" ]; then
    sectionText "NETRC: remove .netrc file"
    remove_recursive $HOME/.netrc
  fi
}

update_apt_cache() {
  if is_in_list "--force" "$*" || [ ! -e "$APT_CACHE_REFRESHED" ] &>> $BUILD_LOG; then
    sectionText "Update apt cache"
    apt-get update -qq &>> $BUILD_LOG
    touch $APT_CACHE_REFRESHED
  fi
}

install_packages() {
  local install_flags="-qq -y -o Dpkg::Options::=--force-confdef"
  local package_description="packages"
  update_apt_cache
  if [ "$1" = "--build" ]; then
    shift
    echo "$*" | tr ' ' '\n' >> /var/tmp/build-deps.list
    package_description="build $package_description"
  fi
  # prepare package list
  local pkg_list="$*"
  # FIX for debian jessie
  DIST=`lsb_release --codename --short`
  if [ "$DIST" = "jessie" ]; then
    sectionText "Found jessie distribution, map package names"
    for r in $JESSIE_PACKAGE_MAP; do
      local from=`echo "$r" | cut -d: -f1`
      local to=`echo "$r" | cut -d: -f2`
      pkg_list=`echo "$pkg_list" | sed "s/$from/$to/g"`
    done
  fi

  if [ -n "$pkg_list" ]; then
    sectionText "Install $package_description: $pkg_list"
    http_proxy=$PROXY eatmydata apt-get install $install_flags $pkg_list &>> $BUILD_LOG
  fi
}

enable_nginx_vhost() {
  if [ ! -e $NGINX_SITES_AVAILABLE/$1.conf ]; then
    errorText "\t nginx vhost '$1' not found! Can't enable vhost!"
    exit 1
  fi
  
  sectionText "Enable nginx vhost $1"
  envsubst '$DOCUMENT_ROOT $PHPFPM_HOST $PHPFPM_PORT $ASSET_BUCKET_NAME' > /etc/nginx/sites-enabled/${1}.conf < /etc/nginx/sites-available/${1}.conf
}

npm_install() {
  local npm_dir="$1"; shift

  if ! is_true $ENABLE_NODEJS; then
    sectionText "SKIP npm install: nodejs is disabled"
    return 0
  fi

  install_packages --build $NPM_BUILD_PACKAGES

  cd "$npm_dir"
  sectionText "$NPM install $NPM_ARGS in ${npm_dir}"
  eatmydata $NPM install $NPM_ARGS $* &>> $BUILD_LOG
}

exec_console() {
  sectionText "Execute 'console $@'"
  $WORKDIR/vendor/bin/console $@
}

# uses the find & sort to select scripts in lexical order (alpine doesn't support `find -s`)
# sources those scripts to make our own data (functions, vars) available to them
exec_scripts() {
  local directory=$1
  
  if [ -d "$directory" ]; then
    get_steps
    
    # provide script counting to inform the user about how many steps are available
    local scripts_count=`echo "$STEPS" | wc -l`
    local scripts_counter=1
    
    for f in $STEPS; do
      local script_name=`basename $f`
      
      sectionHead "Step ($scripts_counter/$scripts_count) $SECTION > $SUBSECTION > $script_name"
      cd $WORKDIR # ensure we are starting within $WORKDIR for all scripts
      source $f
      
      let "scripts_counter += 1"
    done
    
  fi
}

# similar to wait_for_tcp_service, but a one-shot
is_tcp_service_running() {
  nc -w 2 -z $1 $2
}

# retries to connect to an remote address ($1) and port ($2) until the connection could be established
wait_for_tcp_service() {
  local until_seconds=$(($SECONDS + ${$3:-600})) # 600 = 10min, in seconds
  until is_tcp_service_running $1 $2 && [$SECONDS -lt $until_seconds]; do
    sectionText "Wait for tcp://$1:$2 to come up ..."
    sleep 1
  done
  
  if is_tcp_service_running $1 $2; then
    sectionText "Success: tcp://$1:$2 seems to be up, port is open"
    return 0
  else
    errorText "Failed: tcp://$1:$2 could not be reached after $3 seconds"
  fi
  return 1
}

# retries to connect to a url
wait_for_http_service() {
  url=$1; shift
  msg="Wait for $url to come up ..."
  sectionText $msg
  # --connect-timeout <seconds>
  until curl --connect-timeout 2 -s -k  $url -o /dev/null -L --fail $*; do
    sectionText $msg
    sleep 1
  done
  
  sectionText "Success: $1 seems to be up and running"
}

fail() {
  exit=$1; shift
  for line in "$@"; do
    errorText "$line"
  done
  exit $exit
}

retry() {
  if [ $# -lt 2 ] ; then
    fail 1 "Error: wrong number of arguments!" \
           "Usage: retry <max_retries> <command> [<param1> [<param2> [...] ] ]"
  fi

  retries=$1
  shift
  command=$@

  set +e
  echo "Run \`$command\` with $retries retries"
  n=0
  while true; do
    $command && break
    n=$(expr $n + 1)
    if [ $n -le $retries ] ; then
      echo "Retry ($n/$retries)  --  $command"
    else
      fail 2 "ERROR: Max retries. Unable to \`$command\`"
    fi
    sleep 2
  done
  set -e
}

# checks if the given value exists in the list (space separated string
# recommended) parameter $1 => value, $2 => stringified list to search in
is_in_list() {
  local value="$1"; shift
  echo "$*" | tr ' ' '\n' | egrep -i "^($value)\$" > /dev/null
}

is_true() {
  echo "$1" | egrep -i '^(yes|true|1)$' > /dev/null
  return $?
}

stop_timer() {
    MSG="${1:-'Time taken'}"
    local duration=$(($SECONDS - $JOB_START_SECONDS))
    debugText "\n$MSG took: $(($duration / 60)) minutes and $(($duration % 60)) seconds"
    debugText "$MSG finished SUCCESSFULLY"
}

build_exit() {
  rc=$?
  if [ "$rc" != "0" ]; then
    echo -e "\n\nBUILD LOG:"
    tail -n 100 $BUILD_LOG
    echo -e "BUILD FAILED!!!\n\n"
  fi
  exit $rc
}

run_section() {
  SECTION_START_SECONDS=$SECONDS
  get_subsections
  if is_in_list $SECTION "$SECTIONS"; then
    chapterHead "Progress all subsections of $SECTION"
    for SUBSECTION in $SUBSECTIONS; do
      run_subsection
    done
  else
    fail 1 "No main section named $SECTION found! Available: $SECTIONS"
  fi
  JOB_START_SECONDS=$SECTION_START_SECONDS
  stop_timer "Section $SECTION"
}

run_subsection() {
  JOB_START_SECONDS=$SECONDS
  if is_in_list $SUBSECTION "$SUBSECTIONS"; then
    chapterHead "Start $SECTION > $SUBSECTION"
    exec_scripts "$WORKDIR/docker/$SECTION.d/$SUBSECTION/"
    stop_timer "Section $SECTION > $SUBSECTION"
  else
    fail 1 "Subsection $SUBSECTION in $SECTION not found. Available: $SUBSECTIONS"
  fi
}

# Finds all directories within $WORKDIR/docker which ends on *.d and stores them in $SECTIONS
# Those are called main sections
get_sections() {
  # cut: drop the ".d" suffix
  SECTIONS=`find $WORKDIR/docker -mindepth 1 -maxdepth 1 -name '*.d' -type d -exec basename {} \; | cut -d. -f1 | sort`
}

# Finds all directories within $SECTION.d/ and store them in $SUBSECTIONS
# Those are called subsections
get_subsections() {
  SUBSECTIONS=`find $WORKDIR/docker/${SECTION}.d -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort`
}

# Finds all *.sh files in a subsection - those files are called "steps"
get_steps() {
  find_sorted "$WORKDIR/docker/$SECTION.d/$SUBSECTION" ".sh"
  STEPS="$FILES_SORTED"
}

# Stores a list of files found in directory $1 by the given suffix via $2.
# Stores those files in a variable called $FILES_SORTED
find_sorted() {
  local directory="$1"
  local file_suffix="$2"
  FILES_SORTED=`find $directory -name "*$file_suffix" -type f -o -type l | sort`
}

get_section_configuration() {
  SECTION_DESCRIPTION="no description provided"
  CATCH_ALL_EXECUTION="true"
  if [ -f ${WORKDIR}/docker/${SECTION}.d/META ]; then
    source ${WORKDIR}/docker/${SECTION}.d/META
  fi
}

get_subsection_configuration() {
  SECTION_DESCRIPTION="no description provided"
  if [ -f ${WORKDIR}/docker/${SECTION}.d/${SUBSECTION}/META ]; then
    source ${WORKDIR}/docker/${SECTION}.d/${SUBSECTION}/META
  fi
}

print_steps() {
  get_steps
  for STEP in $STEPS; do
    local STEP_FILENAME=$(basename $STEP)
    local format="%-28s %-32s\n"
    printf "$format" "" "$STEP_FILENAME"
  done
}

print_subsections() {
  get_subsections
  for SUBSECTION in $SUBSECTIONS; do
    get_subsection_configuration
    local format="    %-20s %-40s\n"
    printf "$format" "$SUBSECTION" "$SECTION_DESCRIPTION"

    if is_true $PRINT_HELP_WITH_STEPS; then
      print_steps
    fi
  done
}

help() {
  # detect more verbose help
  if [ "$1" = "-v" ]; then
    PRINT_HELP_WITH_STEPS="true"
    shift
  fi

  # print help header
  printf "\n%s\n" "$0 SECTION [subsection] [subsection-args ...]"

  if is_in_list "$1" $SECTIONS; then
    SECTIONS=$1 # reduce list to 1 element
  fi

  # print section and their subsections
  local format="\n  %-10s %-40s\n"
  for SECTION in $SECTIONS; do
    get_section_configuration
    local section_UPPER=`echo $SECTION | tr '[:lower:]' '[:upper:]'`
    printf "$format" "$section_UPPER" "$SECTION_DESCRIPTION"
    print_subsections
  done

  printf "$format" "HELP [-v] [section]" " -v enables printing sections as well"
}
