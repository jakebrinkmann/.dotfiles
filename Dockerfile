# Lightweight (45MB) and Happy Home on debian.
# More tags: //hub.docker.com/_/debian/
FROM debian:stretch

# What am I? Who will I become?
ARG USERNAME=hydrogen
ENV HOME=/home/$USERNAME

# Invincibility Boost.
RUN echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf \
      && apt-get update \
      && apt-get install sudo \
      && useradd -m -s /bin/bash $USERNAME \
      && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME \
      && chmod 0440 /etc/sudoers.d/$USERNAME

# Install the base system dependencies.
# (make language-specific envs later)
#
# NOTE: docker libraries are still required
#       even though the daemon must also be
#       hosted outside the container start
COPY . $HOME/.dots
RUN cd $HOME/.dots \
      && ./install/deb/base.sh \
      && ./setup.sh

# As root, need to change ownership of copied files.
RUN chown -R $USERNAME:$USERNAME $HOME
USER $USERNAME
ENV USER=$USERNAME
WORKDIR $HOME

# Install, and allow ourselves to run, docker
# NOTE: docker.sh fails to add us to the docker
#       group because $USER is `root` behind sudo
RUN sudo ./.dots/install/deb/docker.sh \
      && sudo usermod -aG docker $USERNAME

# Configure how to run the image in a container.
VOLUME [ $HOME ]
ENTRYPOINT [ "/bin/bash" ]
CMD [ "--login" ]

# Example execution to enable editing code on host:
#   docker run --rm -it \
#     -v $PWD:/home/$USERNAME:rw \
#     $IMAGE
