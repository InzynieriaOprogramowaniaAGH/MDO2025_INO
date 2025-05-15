git clone https://github.com/devenes/node-js-dummy-test
cd node-js-dummy-test
sudo dnf install -y npm
npm install
npm start
npm test

docker image pull node
docker run --rm -it node bash
git clone
cd node
npm install
npm start
npm test

docker build -t nodebld -f Dockerfile.nodebld .
docker build -t noderun -f Dockerfile.noderun .
docker run --rm -it noderun
docker build -t nodetest -f Dockerfile.nodetest .
docker run --rm -it nodetest

# commit i push wykonano przy pomocy Source Control w VSCode ale można to zrobić tak
git status
git add -A
git commit -m "message"
git push origin
git status
git log