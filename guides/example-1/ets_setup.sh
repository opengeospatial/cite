echo Example build of ETS of OGC API - Features
cd /app/
wget -O apache-maven-3.8.1-bin.zip https://downloads.apache.org/maven/maven-3/3.8.1/binaries/apache-maven-3.8.1-bin.zip
unzip apache-maven-3.8.1-bin.zip
git clone https://github.com/opengeospatial/ets-ogcapi-features10.git
cd /app/ets-ogcapi-features10
/app/apache-maven-3.8.1/bin/mvn clean package
