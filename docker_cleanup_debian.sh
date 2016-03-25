#!/usr/bin/env bash
#
# simple self destructive cleanUp script for debian/ubuntu OS based docker container build process
#
# @copyright (c) 2015-2016 dunkelfrosch, patrick.paechnatz@gmail.com,
# @version 1.0.0
#
# setup/usage:
#
# 1.) transfer this script using ADD directive inside your Dockerfile:
#
#    ADD
#
# 2.) execute this script inside your container during package-manager related build process has finished:
#
#    RUN set -e sh /opt/docker/cleanup.sh
#
if [ -f /.dockerinit ]; then
    apt-get clean autoclean >/dev/null 2>&1 && \
    apt-get autoremove -y >/dev/null 2>&1
    rm -rf /var/lib/cache /var/lib/log /tmp/* /var/tmp/*
    rm -f  /etc/dpkg/dpkg.cfg.d/02apt-speedup \
           /etc/cron.daily/standard \
           /etc/cron.daily/upstart \
           /etc/cron.daily/dpkg \
           /etc/cron.daily/password \
           /etc/cron.weekly/fstrim && \
    echo '' > /var/log/dpkg.log && \
    echo '' > /var/log/faillog && \
    echo '' > /var/log/lastlog && \
    echo '' > /var/log/bootstrap.log && \
    echo '' > /var/log/alternatives.log && \
    rm -f /opt/docker/cleanup.sh

else
    echo -e "\033[0;31m this script can only be executed inside container environment <EXIT>!\033[0m";
    exit 127
fi
