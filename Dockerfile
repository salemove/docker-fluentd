# renovate: datasource=docker depName=fluent/fluentd
ARG FLUENTD_VERSION=1.4.2
FROM fluent/fluentd:v${FLUENTD_VERSION}-debian-2.0

USER root

COPY Gemfile ./
COPY Gemfile.lock ./

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish
RUN buildDeps="sudo make gcc g++ libc-dev curl ca-certificates bash gnupg libsystemd0" \
 && apt-get update \
 && apt-get install -y --no-install-recommends $buildDeps \
 && sudo gem install bundler -v 2.2.14 \
 && sudo bundler install \
 && sudo gem sources --clear-all \
 && SUDO_FORCE_REMOVE=yes \
    apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  "make" "g++" \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

COPY fluent.conf /etc/fluent/
