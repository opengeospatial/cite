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
      - Waterml 2.0 it will be waterml20
      
1. Determine the version of the tests. It should follow these conventions:  


      <major>.<minor>.<revision>-r1-SNAPSHOT
   
   For example for waterml 2.0 is: 2.0.0-r1-SNAPSHOT

1. Run the following command:
 
         mvn archetype:generate -DarchetypeGroupId=org.opengis.cite -DarchetypeArtifactId=ets-archetype-testng -Dets-code={name}
   
   so for waterml 2.0 will be:
   
         mvn archetype:generate -DarchetypeGroupId=org.opengis.cite -DarchetypeArtifactId=ets-archetype-testng -Dets-code=waterml20

   Answer the questions. Use the defaults.

