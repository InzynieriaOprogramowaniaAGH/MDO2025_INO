    1  logout
    2  sudo dnf install -y git openssh
    3  git --version
    4  ls
    5  pwd
    6  mkdir devOps
    7  cd devOps
    8  git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
    9  ls
   10  cd MDO2025_INO/
   11  ssh-keygen -t ed25519 -C "rusinkdawid@gmail.com"
   12  ssh-keygen -t ecdsa -C "rusinkdawid@gmail.com"
   13  eval "$(ssh-agent -s)"
   14  ssh-add ~/.ssh/id_ed25519
   15  cat ~/.ssh/id_ed25519.pub
   16  ssh -T git@github.com
   17  cd ..
   18  git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
   19  rm
   20  rm -rf MDO2025_INO/
   21  git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
   22  git checkout main
   23  cd MDO2025_INO/
   24  git checkout main
   25  git checkout GLC06
   26  git checkout GCl06
   27  git checkout GCL06
   28  git checkout -b DR416985
   29  ls
   30  cd ITE
   31  ls
   32  cd GCL06/
   33  ls
   34  mkdir DR416985
   35  ls
   36  cd ..
   37  cd ../..
   38  ls
   39  cd MDO2025_INO/
   40  ls -la .git/hooks
   41  nano .git/hooks/commit-msg
   42  chmod +x .git/hooks/commit-msg
   43  ip a
   44  logout
   45  ls
   46  cd devOps/
   47  ls
   48  cd ..
   49  clear
   50  ls
   51  rm -rf Build devOps irssi
   52  rm -rf .git
   53  rm ~/.ssh/id_*
   54  ls
   55  rm -rf build
   56  ls
   57  git --version
   58  clear
   59  sudo dnf install git openssh -y
   60  git --version
   61  ssh -v
   62  git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
   63  ls
   64  cd MDO2025_INO/
   65  ls
   66  git status
   67  cd ~
   68  ssh-keygen -t ed22519 -C "drusin@student.agh.edu.pl"
   69  ssh-keygen -t ed25519 -C "drusin@student.agh.edu.pl"
   70  ssh-keygen -t ecdsa -C "drusin@student.agh.edu.pl"
   71  cat ~/.ssh/id_ed25519.pub
   72  nano ~/.ssh/config
   73  ssh -T git@github.com
   74  git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
   75  clear
   76  cd MDO2025_INO/
   77  git checkout main
   78  git branch -r
   79  git checkout DR416985
   80  git checkout GCL06
   81  git checkout
   82  git branch -r
   83  git branch -d DR416985
   84  git branch -D DR416985
   85  git checkout GCL06
   86  git checkout -b DR416985
   87  ls
   88  cd ITE
   89  ls
   90  cd GCL06
   91  ls
   92  mkdir DR416985
   93  clear
   94  ls
   95  cd DR416985/
   96  ls
   97  nano  commit-msg
   98  rm commit-msg
   99  nano  commit-msg
  100  chmod +x .git/hooks/commit-msg
  101  cp commit-msg .git/hooks/commit-msg
  102  cd ..
  103  ls
  104  touch .git/hooks/commi-msg
  105  ls
  106  nano .git/hooks/commit-msg
  107  cd ITE/
  108  ls
  109  cd GCL06/
  110  ls
  111  cd DR416985/
  112  ls
  113  nano commit-msg 
  114  rm commi-msg
  115  rm commit-msg
  116  ls
  117  cd ..
  118  ls
  119  cd ..
  120  ls
  121  nano commit-msg 
  122  chmod +x .git/hooks/commit-msg
  123  cd ITE/
  124  cd GCL06/
  125  ls
  126  cd DR416985/
  127  echo "test" test.txt
  128  git add test.txt
  129  ls
  130  git add .
  131  git commit -m "cos"
  132  echo "Test" > test.txt
  133  git add test.txt
  134  git commit -m "cos"
  135  cd ..
  136  ls -l .git/hooks/commit-msg
  137  cat .git/hooks/commit-mgs
  138  cat .git/hooks/commit-msg
  139  nano .git/hooks/commit-msg
  140  git commit -m "cos"
  141  chmod +x .git/hooks/commit-msg
  142  echo "test" > test2.txt
  143  git add test2.txt
  144  git commit -m "test"
  145  git add .
  146  git commit -m "DR416985 ciezkie zycie"
  147  git push origin DR416985
  148  git pull origin DR416985 --rebase
  149  git push origin DR416985
  150  mv ~/MDO2025_INO/test2.txt ITE/GCL06/DR416985/
  151  ls
  152  mv ~/MDO2025_INO/commit-msg ITE/GCL06/DR416985/
  153  git add .
  154  git commit -m "DR416985 przeniesiono pliki do właściwego katalogu"
  155  git push origin DR416985
  156  history > ITE/GCL06/DR416985/historia.md
