FROM nixos/nix:2.3

RUN nix-env -i stack
WORKDIR /opt
ARG BASEDIR=.
COPY $BASEDIR/stack.yaml .
COPY $BASEDIR/package.yaml .
RUN stack build --dependencies-only
COPY $BASEDIR .
RUN stack build --ghc-options="-O2" --copy-bins --local-bin-path bin
CMD ./bin/notcat $STATSD_HOST $STATSD_PORT
