FROM ruby:4.0-slim

ENV APP_HOME="/app_home"
ENV BUNDLE_PATH="${APP_HOME}/vendor/bundle"
ENV PATH="${APP_HOME}/bin:${BUNDLE_PATH}/bin:${PATH}"

WORKDIR $APP_HOME

ARG UID=1000
ARG GID=1000

EXPOSE 3000

ENTRYPOINT ["./bin/docker-entrypoint"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
