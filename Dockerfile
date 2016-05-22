FROM ubuntu:16.04

MAINTAINER Florian Finke <florian@finke.email>

ENV PYENV_VERSION 2.7.11 3.1.5 3.2.6 3.3.6 3.4.3 3.5.1

ENV PYENV_ROOT /pyenv/
ENV PATH /pyenv/shims:/pyenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PYENV_INSTALLER_ROOT /pyenv-installer/
ENV PYENV_REQUIRED_PYTHON_BASENAME python_versions.txt
ENV PYENV_REQUIRED_PYTHON /pyenv-config/$PYENV_REQUIRED_PYTHON_BASENAME

RUN apt-get update -y
RUN apt-get install --no-install-recommends -y build-essential \
    python2.7 python2.7-dev git make \
    libssl-dev libffi-dev libbz2-dev libreadline-dev libsqlite3-dev \
    python-pip libjpeg-dev zlib1g-dev python-imaging libxml2-dev \
    libxslt1-dev python-setuptools python-lxml openssh-client \
    curl

RUN pip install --upgrade setuptools pip tox tox-pyenv fabric

RUN mkdir -p ~/.ssh
RUN echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash

RUN apt-get -y install nodejs
RUN git clone https://github.com/yyuu/pyenv.git $PYENV_ROOT

COPY python_versions.txt $PYENV_REQUIRED_PYTHON
RUN while read line; do \
    pyenv install $line || exit 1 ;\
    done < $PYENV_REQUIRED_PYTHON

RUN pyenv global $PYENV_VERSION
RUN pyenv local $PYENV_VERSION
