FROM ruby:3.2.2-slim-bookworm

ENV APP_HOME="/app_home"
ENV BUNDLE_PATH="${APP_HOME}/vendor/bundle"
ENV PATH="${APP_HOME}/bin:${BUNDLE_PATH}/bin:${PATH}"

WORKDIR $APP_HOME

ARG UID=1000
ARG GID=1000

RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential git libpq-dev curl \
 && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key -o /etc/apt/keyrings/nodesource.asc \
 && echo 'deb [signed-by=/etc/apt/keyrings/nodesource.asc] https://deb.nodesource.com/node_20.x nodistro main' | tee /etc/apt/sources.list.d/nodesource.list \
 && apt-get update && apt-get install -y --no-install-recommends nodejs \
 && corepack enable \
 && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
 && apt-get clean \
 && groupadd -g "${GID}" ruby \
 && useradd --create-home --no-log-init -u "${UID}" -g "${GID}" ruby \
 && chown -R ruby:ruby $APP_HOME

EXPOSE 3000

ENTRYPOINT ["./bin/docker-entrypoint"]
CMD ["./bin/docker-start"]
