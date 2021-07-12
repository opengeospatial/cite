FROM adoptopenjdk/openjdk8

ADD . /app/

RUN apt-get update && apt-get install -y git && apt-get install -y wget && apt-get install -y unzip

CMD ["sh","/app/ets_setup.sh"]
