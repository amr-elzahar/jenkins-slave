FROM ubuntu:22.04

USER root

RUN mkdir -p /var/jenkins_home /home/jenkins
RUN groupadd jenkins \
   && useradd -g jenkins jenkins

RUN chown -R jenkins:jenkins /var/jenkins_home \
   && chown -R jenkins:jenkins /home/jenkins

WORKDIR /home/jenkins

RUN apt-get update && apt-get dist-upgrade -y && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y \
   git \
   openjdk-11-jdk \
   maven \
   apt-transport-https \
   curl \
   init \
   openssh-server openssh-client \
   docker.io \
   vim \
   && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
   && apt-get install -y ca-certificates curl
RUN curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update \
   && apt-get install -y kubectl

RUN apt-get update \
   && apt-get upgrade -y
RUN apt-get install -y nodejs npm

COPY init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 22

ENTRYPOINT [ "/usr/local/bin/init.sh" ]
CMD [ "tail" ,"-f", "/dev/null" ]