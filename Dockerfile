FROM ubuntu:18.04

SHELL ["/bin/bash", "-c"]

ARG GIT_FORK

# update the repo base and upgrade
# whatever needs it
RUN apt-get update -y
RUN apt-get upgrade -y

# set this so we don't get dialogs
ENV DEBIAN_FRONTEND=noninteractive

# we'll need sudo and git to
# get things rolling
RUN apt-get install -y sudo make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl \
git mongodb

# Install Chrome for Selenium
COPY google-chrome-stable_current_amd64.deb /chrome.deb
RUN dpkg -i /chrome.deb || apt-get install -yf
RUN rm /chrome.deb

# Install chromedriver for Selenium
COPY chromedriver /usr/local/bin/chromedriver
RUN chmod +x /usr/local/bin/chromedriver

# copy in the included sudoers
# file to give proper access 
# to the user we're about to make
COPY sudoers /etc/sudoers
RUN chmod 0640 /etc/sudoers

# create an ubuntu user so we don't
# do everything as root
RUN useradd -m -s /bin/bash ubuntu
WORKDIR /home/ubuntu
USER ubuntu

# get the pyenv environment set up
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# set the correct environment variables
ENV HOME /home/ubuntu
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN pyenv install 3.6.8
RUN pyenv global 3.6.8

RUN git clone ${GIT_FORK} ~/noob_snhubot
#RUN mkdir ~/noob_snhubot/cfg
COPY mongo.yml /home/ubuntu/noob_snhubot/cfg/mongo.yml
COPY slack.yml /home/ubuntu/noob_snhubot/cfg/slack.yml
WORKDIR /home/ubuntu/noob_snhubot
RUN pip install -r requirements.txt

USER root
COPY subjects.bson /subjects.bson

CMD ["/usr/bin/mongod", "--config", "/etc/mongodb.conf"]
