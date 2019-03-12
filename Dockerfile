# Lightweight (45MB) and Happy Home on debian.
# More tags: //hub.docker.com/_/debian/
ARG DEBIAN_VERSION=stretch
FROM debian:${DEBIAN_VERSION} as base

# The docker user seems like a good choice here
ARG DOCKER_USER=docker
ENV HOME=/home/$DOCKER_USER \
    DOCKER_USER=$DOCKER_USER \
    LANG=en_US.UTF-8

# Invincibility Boost.
RUN echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf \
  && apt-get update \
  && apt-get install sudo \
  && useradd --uid 1000 --create-home --shell /bin/bash $DOCKER_USER \
  && echo "$DOCKER_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$DOCKER_USER \
  && chmod 0440 /etc/sudoers.d/$DOCKER_USER

# Install the base system dependencies.
# (make language-specific envs later)
WORKDIR $HOME/.dots
COPY ./install/base.sh ./install/base.sh
RUN ./install/base.sh
COPY ./install/su-exec.sh ./install/su-exec.sh
RUN ./install/su-exec.sh

# Link files/folders in .dots/dots
COPY . $HOME/.dots
RUN ./symlinks.sh

# Install/configure emacs
# (note: assumes symlinks.sh was successful)
RUN ./install/emacs.sh

# As root, need to change ownership of copied files.
RUN chown -R $DOCKER_USER:$DOCKER_USER $HOME
WORKDIR $HOME

# Configure how to run the image in a container.
# NOTE: using the shell-form to expand envvar
VOLUME [ $HOME ]
ENTRYPOINT su-exec $DOCKER_USER:1000 /bin/bash --login

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FROM base as dkr

# Install, and allow user to run, docker
# NOTE: docker libraries are still required
#       even though the daemon must also be
#       hosted outside the container start
# NOTE: docker group to avoid needing sudo
RUN cd $HOME/.dots \
  && ./install/docker.sh \
  && usermod -aG docker $DOCKER_USER

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FROM base as py

# Install both Pipenv (python/PyPi) & Conda (non-wheel binaries)
# TODO: add pipenv
RUN cd $HOME/.dots \
  && ./install/conda.sh

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FROM base as node

# TODO:
RUN cd $HOME/.dots \
  && ./install/nodejs.sh

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FROM base as clj

# TODO:
RUN cd $HOME/.dots \
  && ./install/clojure.sh
