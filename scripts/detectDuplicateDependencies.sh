#!/bin/bash
listOfRepositories='listOfRepositories.conf'
tmpDirectoryClones=tmp-clones

# Configure names of temporary files
dependencyTreeFile=dependency-tree.txt
dependencyTreeProcessedFile=dependency-tree-processed.txt
allDependenciesFile=all-dependencies.txt
allDependenciesCleanedFile=all-dependencies-cleaned.txt
allDependenciesSortedFile=all-dependencies-sorted.txt

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

function detectDependencies() {
  (
  cd ${tmpDirectoryClones} || exit
  echo Detecting dependencies in clones
  for d in */ ; do
    (
    cd "${d}" || exit
    echo Detecting dependencies in "${d}"
    mvn dependency:tree -DoutputType=dot -DoutputFile=${dependencyTreeFile} -q
    )
  done
  )
}

function processListsWithDependencies() {
  (
  cd ${tmpDirectoryClones} || exit
  echo Processing lists with dependencies
  for d in */ ; do
    echo Processing list of "${d}"
    # Consider sub modules
    find "${d}"/*/ -name ${dependencyTreeFile} -exec cat {} >> "${d}"/${dependencyTreeFile} \;
    # Remove obsolete content
    grep \> "${d}"/${dependencyTreeFile} | cut -d\> -f2 > "${d}"/${dependencyTreeProcessedFile}
    # Write repo name to each line
    sed -i "s/\" ;/:${d::-1}/g" "${d}"/${dependencyTreeProcessedFile}
    # Remove remaining ' "'
    sed -i "s/ \"//g" "${d}"/${dependencyTreeProcessedFile}
  done
  )
}

function writeAllDependenciesIntoSingleFile() {
  (
  cd ${tmpDirectoryClones} || exit
  echo Writing all dependencies into file ${allDependenciesFile}
  for d in */ ; do
    echo Writing dependencies of "${d}" into file ${allDependenciesFile}
    cat "${d}"/${dependencyTreeProcessedFile} >> ${allDependenciesFile}
  done
  )
}

function processFileWithAllDependencies() {
  # Remove obsolete content
  echo Removing obsolete content from ${allDependenciesFile}
  IFS=":"
  while read -r p; do
    read -r -a strarr <<< "${p}"
    if [ -z "${strarr[6]}" ]; then
      echo "${strarr[0]}":"${strarr[1]}":"${strarr[3]}":"${strarr[5]}"\ >> ${tmpDirectoryClones}/${allDependenciesCleanedFile}
    else
      echo "${strarr[0]}":"${strarr[1]}":"${strarr[4]}":"${strarr[6]}"\ >> ${tmpDirectoryClones}/${allDependenciesCleanedFile}
    fi
  done < ${tmpDirectoryClones}/${allDependenciesFile}
  # Sort lines of file alphabetically and remove duplicate lines
  echo Sorting lines of file ${allDependenciesCleanedFile} alphabetically and removing duplicate lines
  sort -u ${tmpDirectoryClones}/${allDependenciesCleanedFile} > ${tmpDirectoryClones}/${allDependenciesSortedFile}
}

function detectAndPrintDuplicateDependencies() {
  echo
  echo Results:
  echo --------
  while read -r p; do
    read -r -a strarr <<< "${p}"
    local artifact="${strarr[0]}":"${strarr[1]}"
    local allArtifacts=$(grep "${artifact}" ${tmpDirectoryClones}/${allDependenciesSortedFile})
    local numberOfArtifacts=$(grep -c "${artifact}" ${tmpDirectoryClones}/${allDependenciesSortedFile})
    if [ "${numberOfArtifacts}" -gt 1 ]; then
      local currentVersion=""
      while IFS= read -r line; do
        read -r -a strarr <<< "${line}"
        if [ "${currentVersion}" != "${strarr[2]}" ] && [ "${currentVersion}" != "" ]; then
          echo "${p}"
          break
        else
          currentVersion="${strarr[2]}"
        fi
      done <<< "${allArtifacts}"
    fi
  done < ${tmpDirectoryClones}/${allDependenciesSortedFile}
}

function cleanUp() {
  rm -rf ${tmpDirectoryClones}
}

setUp
cloneRepositories
detectDependencies
processListsWithDependencies
writeAllDependenciesIntoSingleFile
processFileWithAllDependencies
detectAndPrintDuplicateDependencies
cleanUp
