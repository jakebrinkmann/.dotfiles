FROM centos:7
RUN yum install -y neovim git which wget httpie sudo

RUN useradd -m jake \
	&& echo 'jake ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/jake \
	&& chmod 0440 /etc/sudoers.d/jake \
	&& mkdir -p /home/jake \
	&& chown -R jake:jake /home/jake
USER jake
ENV HOME=/home/jake

COPY . ${HOME}/.dots
RUN cd ${HOME}/.dots && bash setup.sh

