FROM ruby:3.2.1

ENV APP_HOME="/app_home" \
    BUNDLE_PATH="${APP_HOME}/vendor/bundle" \
    BUNDLE_WITHOUT="production"

RUN curl -fsSL https://deb.nodesource.com/setup_19.x | bash -
RUN apt-get install -y nodejs

WORKDIR $APP_HOME

# alias rspec
RUN echo '#!/bin/bash\nRAILS_ENV=test bundle exec rspec "$@"' > /usr/bin/rspec && \
          chmod +x /usr/bin/rspec
# alias rails
RUN echo '#!/bin/bash\nRAILS_ENV=development bundle exec rails "$@"' > /usr/bin/rspec && \
          chmod +x /usr/bin/rspec

EXPOSE 3000

ENTRYPOINT ["./entrypoint.sh"]
CMD ["./start.sh"]
