FROM centos:7
RUN yum install -y vim git which wget httpie sudo

RUN useradd -m jake \
	&& echo 'jake ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/jake \
	&& chmod 0440 /etc/sudoers.d/jake

ENV HOME=/home/jake
COPY . ${HOME}/.dots
RUN cd ${HOME}/.dots \
	&& bash setup.sh
RUN chown -R jake:jake ${HOME}

USER jake
