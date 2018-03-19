FROM phusion/baseimage:latest
MAINTAINER Jesus Macias <me@jesusmacias.es>
ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV HOME /root

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody
RUN usermod -g 100 nobody

# Activar SSH
RUN rm -fr /etc/service/sshd/down
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Update root password
# CHANGE IT # to something like root:ASdSAdfÑ3
RUN echo "root:CyB3rS3cUriTy" | chpasswd

# Enable ssh for root
RUN sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
# Enable this option to prevent SSH drop connections
RUN printf "ClientAliveInterval 15\\nClientAliveCountMax 8" >> /etc/ssh/sshd_config

RUN apt-get update && apt-get install -y python3-pip software-properties-common steghide

RUN ln -s /usr/bin/python3.5 /usr/bin/python

RUN pip3 install --upgrade pip && ln -s /usr/bin/pip3 /usr/bin/pip && pip3 install cryptography

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22

VOLUME ["/opt/data"]

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

