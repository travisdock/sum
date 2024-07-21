FROM ruby:3.3.3-slim-bookworm

ENV APP_HOME="/app_home"
ENV BUNDLE_PATH="${APP_HOME}/vendor/bundle"
ENV PATH="${APP_HOME}/bin:${BUNDLE_PATH}/bin:${PATH}"

WORKDIR $APP_HOME

ARG UID=1000
ARG GID=1000

RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential git curl \
 && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
 && apt-get clean \
 && groupadd -g "${GID}" ruby \
 && useradd --create-home --no-log-init -u "${UID}" -g "${GID}" ruby \
 && chown -R ruby:ruby $APP_HOME

EXPOSE 3000

ENTRYPOINT ["./bin/docker-entrypoint"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
