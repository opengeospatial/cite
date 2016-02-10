#!/bin/bash
#build_release

# Builds a release from current directory (should be master), commits and publishes the new tag in github pages
# it requires to GNU sed. For mac look here: http://stackoverflow.com/questions/30003570/how-to-use-gnu-sed-on-mac-os-x


publishGitHubPages(){
	folder=target/site
	if [ $# -eq 0 ]
	then
	    # "No arguments provided"
	    folder=target/site
	else
	   folder=$1
	fi

	echo "Creating github page for $folder"

	git push origin --delete gh-pages  

	# needs to be under root of a cite maven project, where target/site is available 
	# is in the ignore file - need to force add
	git add -f $folder 
	git commit -m 'publish web site'
	# move it to gh-pages
	git subtree push --prefix $folder origin gh-pages 
	# remove the commit
	git reset HEAD 
	git rm -r target/site 
	git commit -m 'clean project removing files created to publish the web site' 
	git push origin master 
}

# removes snapshot from pom, 
echo '----------------'
mvn package -DskipTests=true
dir=$(pwd)
test_name=$(basename $dir)
test_abbrev=$(echo $test_name |sed 's/ets-//' | sed -E 's/[0-9]+//')
test_version=$(echo $test_name |sed 's/ets-//' | sed -E 's/[a-z]+//')

echo 'Building  a new release for' $test_abbrev ' ' $test_version

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



#commits changes in pom'


git add pom.xml
git clean -f
git commit -m "update pom file to new release: $version"
git tag $version 
git push origin $version
#echo 'creating new build files to upload to the server'
mvn clean install

cd $dir

#creates a github page

echo 'publishing ghpages'
# publishGitHubPages &> /dev/null
echo ' update version to $new_version_number'

# updates pom with the new version

sed -i '0,/<version>'$version'/s//<version>'$new_version_number'-SNAPSHOT/' pom.xml

git add pom.xml
git clean -f
git commit -m "update pom file to $new_version_number-SNAPSHOT version"
git push origin master

echo 'issue name:  '$test_abbrev' '$test_version' revision' $version 'in Beta'
echo 'to be created here: https://github.com/opengeospatial/te-releases/issues'

