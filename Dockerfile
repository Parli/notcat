FROM nixos/nix:2.3

RUN nix-env -i stack
ARG BASEDIR=.
COPY $BASEDIR/statsd.sh ./statsd.sh
RUN ./statsd.sh # prefetch dependencies
CMD ./statsd.sh $STATSD_HOST $STATSD_PORT
