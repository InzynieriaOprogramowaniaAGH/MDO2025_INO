ARG BUILDER_VERSION

FROM tm-builder:${BUILDER_VERSION} AS test

WORKDIR /app

CMD ["mvn", "test"]
