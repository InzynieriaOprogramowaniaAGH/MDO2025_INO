FROM debian:12-slim

WORKDIR /app
COPY kagikachi /app
RUN chmod +x ./kagikachi
WORKDIR /
RUN pwd
RUN ls -al /app
RUN find /app -type f
RUN stat /app/kagikachi
EXPOSE 7878
ENTRYPOINT ["/app/kagikachi"]