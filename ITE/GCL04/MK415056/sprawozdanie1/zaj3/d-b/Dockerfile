FROM  ubuntu:latest
WORKDIR /sds
RUN apt-get update 
RUN apt-get install -y git make gcc 
RUN git clone https://github.com/antirez/sds.git
RUN cd sds && make
