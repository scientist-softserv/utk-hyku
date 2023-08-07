FROM ghcr.io/samvera/hyku/base:9b7b8734 as hyku-base
# The bunder and asset build are ONBUILD commands in the base. they still get run
# as if they were included right after the from line. See https://docs.docker.com/engine/reference/builder/#onbuild
RUN sed -i '/require .enumerator./d' /usr/local/bundle/gems/sass-3.7.4/lib/sass/util.rb
RUN ln -sf /app/samvera/branding /app/samvera/hyrax-webapp/public/branding

FROM hyku-base as hyku-worker
CMD ./bin/worker
