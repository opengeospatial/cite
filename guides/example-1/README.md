# Example Dockerfile for Building an ETS

This example illustrates how to build an ETS in a Docker Image.

## Building

From this `example-1` folder, execute the following command to build the docker image.

`docker build -t etsexample:local .`

The build instals git, wget and unzip in the `adoptopenjdk/openjdk8` image.

## Running

Now execute the following command to run the docker image. This will 

`docker run etsexample:local `

When the image runs, it installs maven, clones the ETS folder and then runs `mvn clean package` on the ETS.
