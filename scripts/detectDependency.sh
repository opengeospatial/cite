#!/bin/bash
dependency=${1}
listOfRepositories='listOfRepositories.conf'
tmpDirectoryClones=tmp-clones

# Configure names of temporary files
dependencyTreeFile=dependency-tree.txt

function checkPreconditions() {
  if [ -z "${dependency}" ]; then
    echo Please set first argument specifying dependency to be detected, pattern: groupId:artifactId
    exit
  fi
}

function setUp() {
  rm -rf ${tmpDirectoryClones}
  mkdir ${tmpDirectoryClones}
}

function cloneRepositories() {
  echo Cloning all repositories listed in $listOfRepositories
  while read -r p; do
    (
    cd ${tmpDirectoryClones} || exit
    echo Cloning "${p}"
    git clone --depth 1 -q "${p}"
    )
  done < ${listOfRepositories}
}

function detectDependency() {
  (
  cd ${tmpDirectoryClones} || exit
  echo Detecting dependency "${dependency}" in clones
  for d in */ ; do
    (
    cd "${d}" || exit
    echo Detecting dependency "${dependency}" in "${d}"
    mvn dependency:tree -DoutputFile=${dependencyTreeFile} -Dincludes="${dependency}" -q
    )
  done
  )
}

function printRepositoriesWithDependency() {
  (
  cd ${tmpDirectoryClones} || exit
  echo
  echo Results:
  echo --------
  for d in */ ; do
    # Consider sub modules
    find "${d}"/*/ -name ${dependencyTreeFile} -exec cat {} >> "${d}"/${dependencyTreeFile} \;
    if [ -s "${d}"/${dependencyTreeFile} ]; then
      echo "${d}" contains dependency "${dependency}"
    fi
  done
  )
}

function cleanUp() {
  rm -rf ${tmpDirectoryClones}
}

checkPreconditions
setUp
cloneRepositories
detectDependency
printRepositoriesWithDependency
cleanUp
