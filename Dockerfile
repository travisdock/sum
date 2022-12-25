FROM ruby:3.1.3

ENV APP_HOME="/app_home"
ENV BUNDLE_PATH="${APP_HOME}/vendor/bundle"

RUN curl -fsSL https://deb.nodesource.com/setup_19.x | bash -
RUN apt-get install -y nodejs

WORKDIR $APP_HOME

EXPOSE 3000

ENTRYPOINT ["./entrypoint.sh"]
CMD ["./start.sh"]
