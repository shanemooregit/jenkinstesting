FROM ubuntu:18.04
RUN apt-get update
RUN apt-get -y install jq
RUN pwd
RUN ls -lah