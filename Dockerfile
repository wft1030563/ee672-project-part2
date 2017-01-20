FROM ubuntu:14.04
MAINTAINER Hason Tse <fon09181996@gmail.com>

WORKDIR /opt
RUN apt-get -y update
RUN apt-get install -y wget unzip cmake python-dev python-pip gfortran gcc   #install missed dev
RUN wget https://github.com/cvxopt/cvxopt/archive/master.zip
RUN wget https://sourceforge.net/projects/math-atlas/files/Stable/3.10.3/atlas3.10.3.tar.bz2
RUN wget http://www.netlib.org/lapack/lapack-3.4.0.tgz
RUN wget http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-4.5.3.tar.gz     #download cvxopt,atlas,lapack,SuiteSparse
RUN apt-get -y upgrade

RUN unzip master.zip
RUN tar -jxvf atlas3.10.3.tar.bz2
RUN tar -vxf lapack-3.4.0.tgz
RUN tar -vxf SuiteSparse-4.5.3.tar.gz           #unzip them

WORKDIR /opt/lapack-3.4.0
RUN wget https://github.com/wft1030563/ee672-project-part2/blob/master/make.inc.example1.zip?raw=true
RUN unzip make.inc.example1.zip?raw=true
RUN mv make.inc.example1 make.inc
RUN wget https://github.com/wft1030563/ee672-project-part2/blob/master/Makefile1.zip?raw=true
RUN unzip Makefile1.zip?raw=true
RUN rm Makefile
RUN mv Makefile1 Makefile
RUN make

WORKDIR /opt
RUN export CVXOPT_SUITESPARSE_SRC_DIR=$(pwd)/SuiteSparse

RUN mv cvxopt-master cvxopt  
RUN mv ATLAS ATLAS3.10.3

WORKDIR /opt/ATLAS3.10.3
RUN mkdir Linux_C2D64SSE3
WORKDIR /opt/ATLAS3.10.3/Linux_C2D64SSE3

RUN ../configure -b 64 -D c -DPentiumCPS=2400 -Fa alg -fPIC --with-netlib-lapack-tarfile=/opt/lapack-3.4.0.tgz --prefix=/opt/atlas #
RUN make clean
RUN make build                                    # tune & build lib
RUN make check                                    # sanity check correct answer
#RUN make ptcheck                                  # sanity check parallel
RUN make time                                     # check if lib is fast
RUN make install

WORKDIR /opt/cvxopt
RUN wget https://github.com/wft1030563/ee672-project-part2/blob/master/setup_new.py.zip?raw=true
RUN unzip setup_new.py.zip?raw=true
RUN apt-get -y install python-dev #liblapack-dev

WORKDIR /opt
RUN export CVXOPT_SUITESPARSE_SRC_DIR=$(pwd)/SuiteSparse
RUN export CVXOPT_SUITESPARSE_SRC_DIR=$(pwd)/SuiteSparse
RUN export CVXOPT_SUITESPARSE_SRC_DIR=$(pwd)/SuiteSparse
ENV export CVXOPT_SUITESPARSE_SRC_DIR=$(pwd)/SuiteSparse
WORKDIR /opt/cvxopt
#RUN python setup_new.py install
#WORKDIR /opt
#RUN export CVXOPT_SUITESPARSE_SRC_DIR=$(pwd)/SuiteSparse
#WORKDIR /opt/cvxopt
#RUN python setup_new.py install
#
#RUN apt-get -y update

#RUN apt-get -y install python-cvxopt
#RUN apt-get -y remove libblas*
#RUN apt-get -y install python-cvxopt              #make sure that no libblas* but don't remove cvxopt after removing libblas*

EXPOSE 80
