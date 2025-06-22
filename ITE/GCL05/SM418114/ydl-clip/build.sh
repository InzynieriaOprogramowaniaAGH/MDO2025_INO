docker build -t ydl-clip -f Dockerfile.run .
docker build --no-cache -t ydl-clip-build -f Dockerfile.build .
docker build -t ydl-clip-test -f Dockerfile.test .
docker build -t ydl-clip-phar -f Dockerfile.phar .
