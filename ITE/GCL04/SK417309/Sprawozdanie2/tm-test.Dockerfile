ARG BUILDER_VERSION

FROM tm-builder AS test

WORKDIR /app

CMD ["mvn", "test"]
