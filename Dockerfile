ARG RUBY_VERSION=2.7.6
FROM ruby:$RUBY_VERSION-alpine3.15 as builder

RUN apk add build-base
RUN wget -O - https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2 | tar -xj && \
    cd jemalloc-5.2.1 && \
    ./configure && \
    make && \
    make install

FROM ghcr.io/scientist-softserv/dev-ops/samvera:f71b284f as hyku-base

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

COPY --from=builder /usr/local/lib/libjemalloc.so.2 /usr/local/lib/
ENV LD_PRELOAD=/usr/local/lib/libjemalloc.so.2

FROM hyku-base as hyku-worker
CMD ./bin/worker
