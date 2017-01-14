FROM ubuntu:14.04
MAINTAINER Hason Tse <fon09181996@gmail.com>

RUN apt-get update
RUN apt-get install wget unzip cmake python-dev python-pip gfortran

WORKDIR /opt
