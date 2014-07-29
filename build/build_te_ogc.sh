#!/bin/sh
# Build TE with all the tests for OGC
te_tag=4.0.5
parent_dir=/Users/lbermudez/Documents/Dropbox/github/cite/build
# change for TE prod or beta relative to parent dir
# scripts_csv=ctl-scripts-release.csv
scripts_csv=test-one-config.csv

folder_site=site-prod #contains header and footer
folder_to_build=/Users/lbermudez/Documents/Dropbox/software/te_build
catalina_base=/Users/lbermudez/Documents/Dropbox/software/te_build/catalina_base 
tomcat=/Applications/apache-tomcat-7.0.53
war_name=teamengine
temp_ets=/Users/lbermudez/Documents/Dropbox/software/temp_ets
repo_te=$folder_to_build/teamengine

clean=true
download_te=true
download_build_ets_res_and_te_profile=true

## ----- Clean -------------
if [ "$clean" == "true" ]; then
   rm -rf $folder_to_build
   mkdir -p $folder_to_build
fi  

## ------------  Build ETS Resources
# Make sure there is a profile setup: 
# https://github.com/opengeospatial/ets-resources/blob/master/README.md
# ets-resources-version in settings.xml should be the same as the version declared in the pom of ets-resources.
# 2014-0617 version wwas "14.06.DD-SNAPSHOT"

if [ $download_build_ets_res_and_te_profile == true ]; then
   cd $folder_to_build
   git clone file:///Users/lbermudez/Documents/Dropbox/github/ets-resources
   cd ets-resources
   mvn install
 
   ## -------- Build TEAM Engine ----------------

   
   # download TE
   if [ $download_te == true ]; then
      echo "downloading TE"
      cd $parent_dir
      ./build_one.sh $folder_to_build teamengine $te_tag local
   fi

fi  

cd $repo_te
echo "building te war with ogc.cite profile"
mvn -P ogc.cite package

## create and populate catalina base 
rm $catalina_base
mkdir -p $catalina_base
cd $catalina_base
mkdir bin logs temp webapps work lib

# copy from tomcat bin and base files
cp $tomcat/bin/catalina.sh bin/
cp -r $tomcat/conf $catalina_base

# move tomcat to catalina_base
cp $repo_te/teamengine-web/target/teamengine.war $catalina_base/webapps/$war_name.war
unzip -o $repo_te/teamengine-web/target/teamengine-common-libs.zip -d $catalina_base/lib 

#build TE_BASE
mkdir -p $catalina_base/TE_BASE
TE_BASE=$catalina_base/TE_BASE
export $TE_BASE
unzip -o $repo_te/teamengine-console/target/teamengine-console-$te_tag-base.zip -d TE_BASE

cd $parent_dir
cp -r users/ $TE_BASE/users

#create setenv
cd $catalina_base/bin
touch setenv.sh
cat <<EOF >setenv.sh
!/bin/sh
## path to java jdk
## JAVA_HOME=/usr/local/java/jdk7
## export JAVA_HOME

## path to tomcat installation to use
export CATALINA_HOME=$tomcat

## path to server instance to use
export CATALINA_BASE=$catalina_base
export CATALINA_OPTS='-server -Xmx1024m -XX:MaxPermSize=128m -DTE_BASE=$TE_BASE'
EOF

chmod 777 *.sh

#copy scripts from svn and testng
# ctl-scripts-release.csv needs to be updated before
# cd $parent_dir
#./get-ctl.sh $scripts_csv

# build etss
cd $parent_dir
temp_ets=/Users/lbermudez/Documents/Dropbox/software/temp_ets
test_name=ets-kml22
tag=r11-SNAPSHOT

./build_one.sh $temp_ets $test_name $tag local


## ------------------Move the ctl and zips to catalina base---------

# get file that has scripts name and zipped
cd $temp_ets/$test_name/target
ls *.zip > temp_out
zip_ctl_file=`grep scrip temp_out | grep zip | head -1`
rm temp_out

# get file that has the jars
cd $temp_ets/$test_name/target
ls *.zip > temp_out
zip_dep_file=`grep deps temp_out | head -1`
rm temp_out

if [ -n "$zip_ctl_file" ]; then
   unzip -q $temp_ets/$test_name/target/$zip_ctl_file -d $TE_BASE/scripts
   if [ -n "$zip_dep_file" ]; then
       unzip -q -n $temp_ets/$test_name/target/$zip_dep_file -d $catalina_base/lib 
   fi   
else
   echo 'zip file not found: $temp_ets/$test_name/target/$zip_ctl_file'
   exit -1
fi


#create and copy config.xml
#rm new-config.xml
#cat <<EOF > new-config.xml
#<?xml version="1.0" encoding="UTF-8"?>
#<config release="">
#  <scripts>
#   <organization>
#   <name>OGC</name>

#EOF

cd $parent_dir
./parse_configs.py $TE_BASE

# move site folder to TE_BASE
cd $parent_dir
rm -r $TE_BASE/resources/site
cp -r $folder_site/ $TE_BASE/resources/site


echo "catalina_base  was built at" $catalina_base 

cd $catalina_base/bin
./catalina.sh start   

cp -r cd $parent_dir/$folder_site/ $catalina_base/webapps/$war_name/site
