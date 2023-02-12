FROM ruby:3.1.3

ENV APP_HOME="/app_home"
ENV BUNDLE_PATH="${APP_HOME}/vendor/bundle"

RUN curl -fsSL https://deb.nodesource.com/setup_19.x | bash -
RUN apt-get install -y nodejs

WORKDIR $APP_HOME

# RUN echo 'alias rspec="RAILS_ENV=test bundle exec rspec"' >> ~/.bashrc
RUN echo '#!/bin/bash\nRAILS_ENV=test bundle exec rspec "$@"' > /usr/bin/rspec && \
          chmod +x /usr/bin/rspec

EXPOSE 3000

ENTRYPOINT ["./entrypoint.sh"]
CMD ["./start.sh"]
