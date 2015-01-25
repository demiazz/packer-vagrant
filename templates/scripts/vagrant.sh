#!/bin/bash

mkdir ~<%= username %>/.ssh
wget --no-check-certificate \
'https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub' \
-O ~%<%= username %>/.ssh/authorized_keys
chown -R %<%= username %> ~%<%= username %>/.ssh
chmod -R go-rwsx ~%<%= username %>/.ssh
