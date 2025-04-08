ARG BUILDER_VERSION

FROM tm-build:${BUILDER_VERSION} AS test

WORKDIR /app

CMD ["mvn", "test"]
