cd MDO2025_INO/INO/GCL01/AB414799/Sprawozdanie1
mkdir lab_3
cd lab_3

git clone https://github.com/DaveGamble/cJSON.git
cd cJSON/
sudo dnf install gcc cmake make
mkdir build
cd build
cmake ..
make
ctest

docker run -it ubuntu bash
# sekcja kontenera
apt update && apt install -y git build-essential cmake 
git clone https://github.com/DaveGamble/cJSON.git
cd cJSON
cmake ..
make
ctest
# koniec sekcji

nano Dockerfile.build
docker build -t cjson_builder -f Dockerfile.build .
nano Dockerfile.test
docker build -t cjson_tester -f Dockerfile.test .
docker run -t cjson_tester
docker images

git add .
git status
git commit -m "AB414799: lab3 done"
git push origin AB414799