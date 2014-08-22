Guide to generate a new test
==============================

Prerequisites
---------------
Need maven 



Steps
--------

1. Select the name of the test.
   It should be: {abbreviation}{mayorNumber}{minorNumber}
   For example for:
      - GML 3.2.1 it will be gml32   
      - Waterml 2.0 it will be waterml20

1. Run the following command:
 
         mvn archetype:generate -DarchetypeGroupId=org.opengis.cite -Dets-code={name}
   
   so for waterml 2.0 will be:
   
         mvn archetype:generate -DarchetypeGroupId=org.opengis.cite -Dets-code={waterml20}
