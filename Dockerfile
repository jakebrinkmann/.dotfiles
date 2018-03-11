FROM centos:7
RUN yum install -y vim git which wget
USER ec2-user
COPY . /home/ec2-user/.dots
RUN cd /home/ec2-user/.dots && bash setup.sh

