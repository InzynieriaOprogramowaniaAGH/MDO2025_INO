ARG BUILDER_VERSION

FROM tm-build AS test

WORKDIR /app

CMD ["mvn", "test"]
