#!/bin/sh
set -eux

# Copyright 2017 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# Install prerequisites.
clean-install curl ca-certificates make g++ sudo bash gnupg

# Install Fluentd.
/usr/bin/curl -sSL https://toolbelt.treasuredata.com/sh/install-debian-stretch-td-agent3.sh | sh

# Change the default user and group to root.
# Needed to allow access to /var/log/docker/... files.
sed -i -e "s/USER=td-agent/USER=root/" -e "s/GROUP=td-agent/GROUP=root/" /etc/init.d/td-agent

# Install the Elasticsearch Fluentd plug-in.
# http://docs.fluentd.org/articles/plugin-management
td-agent-gem install --no-document fluent-plugin-kubernetes_metadata_filter -v 2.1.6
td-agent-gem install --no-document fluent-plugin-elasticsearch -v 3.5.2
td-agent-gem install --no-document fluent-plugin-dogstatsd -v 0.0.6
td-agent-gem install --no-document fluent-plugin-multi-format-parser -v 1.0.0
td-agent-gem install --no-document fluent-plugin-record-modifier -v 2.0.1
td-agent-gem install --no-document fluent-plugin-systemd -v 1.0.2

# Remove docs and postgres references
rm -rf /opt/td-agent/embedded/share/doc \
  /opt/td-agent/embedded/share/gtk-doc \
  /opt/td-agent/embedded/lib/postgresql \
  /opt/td-agent/embedded/bin/postgres \
  /opt/td-agent/embedded/share/postgresql

apt-get remove -y make g++
apt-get autoremove -y
