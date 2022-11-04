FROM ghcr.io/scientist-softserv/dev-ops/samvera:5eb15236 as hyku-base

COPY --chown=1001:101 $APP_PATH/Gemfile* /app/samvera/hyrax-webapp/
RUN bundle install --jobs "$(nproc)"
COPY --chown=1001:101 $APP_PATH/bin/db-migrate-seed.sh /app/samvera/

COPY --chown=1001:101 $APP_PATH /app/samvera/hyrax-webapp

ARG HYKU_BULKRAX_ENABLED="true"
RUN RAILS_ENV=production SECRET_KEY_BASE=`bin/rake secret` DB_ADAPTER=nulldb DB_URL='postgresql://fake' bundle exec rake assets:precompile
RUN ln -sf /app/samvera/branding /app/samvera/hyrax-webapp/public/branding

FROM hyku-base as hyku-worker
ENV MALLOC_ARENA_MAX=2
CMD ./bin/worker
