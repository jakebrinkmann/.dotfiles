FROM centos:7
RUN yum install -y vim git which wget
COPY . /.dots
RUN cd /.dots && bash setup.sh

