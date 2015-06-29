#!/bin/bash
#build_release

# gets the master, removes snapshot from pom, and tag for new release
# echo 'be sure that you have run and test properly'
# echo 'starting release'
echo '----------------'
mvn package -DskipTests=true
dir=$(pwd)
test_name=$(basename $dir)
test_abbrev=$(echo $test_name |sed 's/ets-//' | sed -E 's/[0-9]+//')

echo 'Building  a new release for $test_name'
echo ''

version_complete=$(echo -e 'setns x=http://maven.apache.org/POM/4.0.0\ncat /x:project/x:version/text()' | xmllint --shell pom.xml | grep -v /)
version=$(echo $version_complete | sed 's/-SNAPSHOT//g') 
## new_version_number=$(($(echo $version | sed 's/r*[0-9].*//')+1))
echo 'version_complete:' $version_complete
if [[ $version == 'r*' ]]; 
then
	echo "version starts with r, this is not ok: $version"
	exit 0
fi

version_n1=$(echo $version | sed -E 's/.[0-9]+//g') 
version_n2=$(echo $version | sed -E 's/[0-9]+\.//g') 
echo 'version_n1:' $version_n1 'and' 'version_n2:' $version_n2
new_version_number=$version_n1.$(($version_n2+1))
echo 'new_version_number:' $new_version_number
sed -i'.orig' 's/-SNAPSHOT//' pom.xml



#echo 'remove first -SNAPSHOT keep the old file in .orig'


git add pom.xml
git clean -f
git commit -m "update pom file to new release: $version"
git tag $version 
git push origin $version
#echo 'creating new build files to upload to the server'
mvn clean install

cd $dir

echo 'publishing ghpages'
pubpage &> /dev/null
echo ' update version to $new_version_number'

sed -i'.orig' 's/<version>'"$version"'<\/version>/<version>'"$new_version_number"'-SNAPSHOT<\/version>/' pom.xml
git add pom.xml
git clean -f
git commit -m "update pom file to $new_version_number-SNAPSHOT version"
git push origin master

