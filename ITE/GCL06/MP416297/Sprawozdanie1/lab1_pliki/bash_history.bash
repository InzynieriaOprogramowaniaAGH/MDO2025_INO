sudo dnf install git-all
git --version
sudo dnf install openssh-server
systemctl start sshd.service
mkdir repo
cd repo
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
ssh-keygen -t ecdsa -b 521 -f ~/.ssh/id_ecdsa
git checkout main
git checkout GCL06
git checkout -b MP416297
cd ITE/GCL06
mkdir MP416297
cd MP416297
mkdir lab1_pliki
cd ~/repo/MDO2025_INO/.git/hooks
nano prepare-commit-msg
chmod a+x prepare-commit-msg
cp prepare-commit-msg ~/repo/MDO2025_INO/ITE/GCL06/MP416297/lab1_pliki
cd ~/repo/MDO2025_INO/ITE/GCL06/MP416297
touch sprawozdanie1.md

# Commity i inne git'owe rzeczy robiłem przy pomocy Source Control w VSC
# Jednak wyglądałoby to mniej więcej w ten sposób

git config --global user.name "Marcin Pieczonka"
git config --global user.email "marcinpieczonka03@gmail.com"

git status
git add -A
git commit -m "test" #ten commit był zrobiony przed utworzeniem hooke'a
# git commit -m "test2" #ten commit był utworzony po utworzeniu hooke'a i miał automatycznie dodany przedrostek
git status
git push origin