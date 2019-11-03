FROM ubuntu:16.04

MAINTAINER Florian Finke <florian@finke.email>

ENV PYTHON_VERSIONS 2.7.13 2.7.14 2.7.15 2.7.16 3.1.5 3.2.6 3.3.6 3.4.5 3.4.6 3.5.2 3.5.3 3.5.4 3.5.5 3.6.1 3.6.3 3.6.4 3.6.5 3.6.6 3.6.7 3.7.0 3.7.1 3.7.2 3.7.3 3.7.4 3.7.5 3.8.0

ENV PYENV_ROOT /pyenv/
ENV PATH /pyenv/shims:/pyenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PYENV_INSTALLER_ROOT /pyenv-installer/
ENV PYENV_REQUIRED_PYTHON_BASENAME python_versions.txt
ENV PYENV_REQUIRED_PYTHON /pyenv-config/$PYENV_REQUIRED_PYTHON_BASENAME

RUN apt-get update -q -y
RUN apt-get install --no-install-recommends --fix-missing -y build-essential \
    python2.7 python2.7-dev git make locales \
    libssl-dev libfontconfig libffi-dev libbz2-dev libreadline-dev libsqlite3-dev \
    python-pip libjpeg-dev zlib1g-dev python-imaging libxml2-dev \
    libxslt1-dev python-lxml openssh-client \
    curl rsync ruby-dev rubygems \
    && apt-get autoremove -y \
        && apt-get clean all \
        && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
        && locale-gen \
        && update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8

RUN pip install --upgrade setuptools
RUN pip install --upgrade pip
RUN pip install --upgrade tox tox-pyenv "fabric<2.0" docker-fabric awscli awsebcli

RUN mkdir -p ~/.ssh
RUN echo "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get -y install nodejs

RUN npm install -g npm@latest yarn

RUN git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT

COPY python_versions.txt $PYENV_REQUIRED_PYTHON
RUN while read line; do \
    pyenv install $line || exit 1 ;\
    done < $PYENV_REQUIRED_PYTHON

RUN pyenv global $PYTHON_VERSIONS
RUN pyenv local $PYTHON_VERSIONS
