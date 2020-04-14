FROM ubuntu:18.04

RUN useradd -ms /bin/bash bower
RUN apt-get update && apt-get install -y \
  build-essential \
  curl \
  openjdk-8-jdk-headless \
  python3 \
  git

RUN curl -sL https://deb.nodesource.com/setup_13.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g bower

RUN apt-get install -y \
  maven \
  zip \
  unzip \
  gcc

# Allows for the use of any bazel version based off a .bazelversion file
RUN mkdir -p /opt/bazelisk
RUN git clone https://github.com/bazelbuild/bazelisk.git /opt/bazelisk/
RUN cp /opt/bazelisk/bazelisk.py /usr/bin/bazel

RUN mkdir -p /opt/src/
WORKDIR /opt/src/
RUN chown -R bower:bower /opt/src
USER bower
RUN git clone -b stable-3.1 https://gerrit.googlesource.com/gerrit

ENV WORKSPACE /opt/src/gerrit

WORKDIR /opt/src/gerrit/plugins
RUN git clone -b stable-3.1 https://gerrit.googlesource.com/plugins/its-base
RUN git clone -b stable-3.1 https://gerrit.googlesource.com/plugins/its-jira

WORKDIR /opt/src/gerrit
RUN bazel build plugins/its-jira
