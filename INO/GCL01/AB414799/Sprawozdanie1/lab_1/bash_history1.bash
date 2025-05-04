sudo systemctl enable --now sshd
sudo systemctl status sshd
sudo dnf install git -y
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
ssh-keygen -t ecdsa -b 521 -f ~/.ssh/id_ecdsa
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "bacaadrian749@gmail.com"
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
cd MDO2025_INO
git checkout GCL01
cd INO/GCL01
git checkout -b AB414799
mkdir AB414799
cd AB414799
touch commit-msg
chmod +x commit-msg
cp commit-msg ../../../.git/hooks
nano sprawozdanie1.md 
git add .
git status
git config user.email "bacaadrian749@gmail.com"
git commit -m "AB414799 Dodano sprawozdanie i hook commit-msg"
git push origin AB414799