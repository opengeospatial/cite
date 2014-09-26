Guide to generate a new test
==============================

Prerequisites
---------------
Need maven 


Steps
--------

1. Determine the name of the test.
   It should be: {abbreviation}{mayorNumber}{minorNumber}

   For example for:
      - GML 3.2.1 it will be gml32   
      - Waterml 2.0.1 it will be waterml20
      
1. Determine the version of the tests. It should follow these conventions:  {major}.{minor}.{revision}-r1-SNAPSHOT

   For example for waterml 2.0.1 is: 2.0.1-r1-SNAPSHOT

1. Run the following command:
 
         mvn archetype:generate -DarchetypeGroupId=org.opengis.cite -DarchetypeArtifactId=ets-archetype-testng -Dets-code={name}
   
   so for waterml 2.0 will be:
   
         mvn archetype:generate -DarchetypeGroupId=org.opengis.cite -DarchetypeArtifactId=ets-archetype-testng -Dets-code=waterml20

   Answer the questions. Use the defaults.
   
1. If not using an interactive mode, the following can be run (using the waterml 2.0.1 example):

         mvn archetype:generate \
         -DinteractiveMode=false \
         -DarchetypeGroupId=org.opengis.cite \
         -DarchetypeArtifactId=ets-archetype-testng \
         -DarchetypeVersion=2.1 \
         -Dets-code=waterml20 \
         -DartifactId=ets-waterml20 \
         -Dversion=2.0.1-r1-SNAPSHOT \
         -Dpackage=org.opengis.cite.waterml20 \
         -Dets-title="WaterML 2.0 Executable Test Suite" 


