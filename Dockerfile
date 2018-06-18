FROM centos:7
RUN yum install -y vim git which wget httpie sudo tmux epel-release emacs

RUN cd /usr/local/bin \
	&& curl -fsSLo boot \
	https://github.com/boot-clj/boot-bin/releases/download/latest/boot.sh \
	&& chmod 755 boot

RUN useradd -m jake \
	&& echo 'jake ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/jake \
	&& chmod 0440 /etc/sudoers.d/jake

ENV HOME=/home/jake
COPY . ${HOME}/.dots
RUN cd ${HOME}/.dots \
	&& bash setup.sh
RUN chown -R jake:jake ${HOME}

USER jake
WORKDIR /home/jake
ENTRYPOINT [ "/bin/bash" ]
CMD [ "--login" ]
