FROM ghcr.io/scientist-softserv/dev-ops/samvera:e9200061 as hyku-base

COPY --chown=1001:101 $APP_PATH/Gemfile* /app/samvera/hyrax-webapp/
RUN sh -l -c " \
  bundle install --jobs "$(nproc)" && \
  sed -i '/require .enumerator./d' /usr/local/bundle/gems/oai-1.1.0/lib/oai/provider/resumption_token.rb && \
  sed -i '/require .enumerator./d' /usr/local/bundle/gems/edtf-3.0.7/lib/edtf.rb && \
  sed -i '/require .enumerator./d' /usr/local/bundle/gems/csl-1.6.0/lib/csl.rb"
COPY --chown=1001:101 $APP_PATH/bin/db-migrate-seed.sh /app/samvera/

COPY --chown=1001:101 $APP_PATH /app/samvera/hyrax-webapp

ARG HYKU_BULKRAX_ENABLED="true"
RUN RAILS_ENV=production SECRET_KEY_BASE=FAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKE DB_ADAPTER=nulldb DB_URL='postgresql://fake' bundle exec rake assets:precompile
RUN ln -sf /app/samvera/branding /app/samvera/hyrax-webapp/public/branding

FROM hyku-base as hyku-worker
ENV MALLOC_ARENA_MAX=2
CMD ./bin/worker
