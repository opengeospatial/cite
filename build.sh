#!/bin/sh
# Builds the test and teamengine for UNIX/OS

# TEAM Engine tag from https://github.com/opengeospatial/teamengine
te_tag=4.0.5

# base to download and install teamengine. 
# change the base if the directory is other than the current user default directory

base=~
TE_BASE=$base/teamengine/TE_BASE
mkdir -p $base/teamengine/TE_BASE/scripts
mkdir -p $base/teamengine/te_build
mkdir -p $base/teamengine/te_install 
folder_to_build=$base/teamengine/te_build
te_install=$base/teamengine/te_install

########
# build the test
mvn install
cd target 
unzip ets-wms-client13-1.3.0-r6.zip $TE_BASE/scripts


#download and build TEAM Engine
cd $folder_to_build
git clone https://github.com/opengeospatial/teamengine.git
cd $base/teamengine/te_build/teamengine
git checkout $te_tag
mvn install
unzip $folder_to_build/teamengine/teamengine-console/target/teamengine-console-$te_tag-bin.zip -d $te_install
unzip $folder_to_build/teamengine/teamengine-console/target/teamengine-console-$te_tag-base.zip -d $TE_BASE

echo "  "
echo "-----------------   "
echo "  "
echo "Congratulations"
echo "  "
echo "TEAM Engine ($te_tag) and the ets-wms-client13-1.3.0-r6 have been installed."
echo "  "
echo " UNIX/OS users - You can run the test with the following command: "
echo "   $base/teamengine/te_install/bin/unix/test.sh -source=wms-client/1.3.0/ctl/main.ctl"
echo "  "
echo " Windows users - You can run the test with the following command:"
echo "  $base/teamengine/te_install/bin/windows/test.bat -source=wms-client/1.3.0/ctl/main.ctl"
echo "  "
echo " Any issue or questions please send an email to the CITE forum: http://cite.opengeospatial.org/forum"