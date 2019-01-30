# Lightweight (45MB) and Happy Home on debian.
# More tags: //hub.docker.com/_/debian/
FROM debian:stretch as base

# The docker user seems like a good choice here
ARG USERNAME=docker
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
COPY . $HOME/.dots
RUN cd $HOME/.dots \
  && ./install/base.sh \
  && ./setup.sh

# As root, need to change ownership of copied files.
RUN chown -R $USERNAME:$USERNAME $HOME
USER $USERNAME
ENV USER=$USERNAME
WORKDIR $HOME

# Configure how to run the image in a container.
VOLUME [ $HOME ]
ENTRYPOINT [ "/bin/bash" ]
CMD [ "--login" ]

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FROM base as dkr
# Use root for privileged/administrative work
USER root

# Install, and allow user to run, docker
# NOTE: docker libraries are still required
#       even though the daemon must also be
#       hosted outside the container start
# NOTE: docker group to avoid needing sudo
RUN $HOME/.dots/install/docker.sh \
  && usermod -aG docker $USERNAME
