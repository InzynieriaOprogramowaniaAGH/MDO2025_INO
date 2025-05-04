FROM fedora:latest
RUN dnf install -y gcc make && dnf clean all
RUN mkdir -p /app/build
RUN echo "zbudowano dnia $(date)" > /app/build/output.txt
CMD ["sleep", "2"]
