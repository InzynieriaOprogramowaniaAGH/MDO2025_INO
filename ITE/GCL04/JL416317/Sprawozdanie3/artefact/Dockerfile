FROM bitnami/minideb:bullseye AS runtime

RUN install_packages libicu67

WORKDIR /app

COPY . .

ENV ASPNETCORE_URLS=http://+:5000

EXPOSE 5000

ENTRYPOINT ["./WeatherForecast.Api"]
