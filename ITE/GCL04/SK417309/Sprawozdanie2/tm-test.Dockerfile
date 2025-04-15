ARG BUILDER_VERSION=1.0

FROM tm-builder:${BUILDER_VERSION} AS test

WORKDIR /app

CMD ["mvn", "test"]
