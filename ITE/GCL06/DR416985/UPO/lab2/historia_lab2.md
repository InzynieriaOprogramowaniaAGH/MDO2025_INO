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
  157  nano ITE/GCL06/DR416985/README.md
  158  cat ITE/GCL06/DR416985/README.md
  159  git add .
  160  git commit -m "DR416985 test"
  161  git push origin DR416985
  162  ls
  163  cd ITE
  164  ls
  165  cd GCL06/
  166  cd DR416985/
  167  ls
  168  cat README.md
  169  rm README.md
  170  nanto report1.md
  171  nano report1.md
  172  git add .
  173  git commit -m "DR416985"
  174  git push origin DR416985
  175  ls
  176  code report1.md
  177  ls
  178  mkdir screen
  179  ls
  180  cd screen
  181  cd ..
  182  rm screen
  183  mv ~/Pulpit/screen1.png ~/MDO2025_INO/ITE/GCL06/DR416985/
  184  cp ~/Pulpit/screen1.png ~/MDO2025_INO/ITE/GCL06/DR416985/
  185  clear
  186  sudo dnf install docker -y
  187  sudo systemctl start docker
  188  sudo systemctl enable docker
  189  sudo systemctl status docker
  190  sudo usermod -aG docker $USER
  191  docker --version
  192  docker pull hello-world
  193  sudo docker pull hello-world
  194  logout
  195  exit
  196  sudo dnf install docker -y
  197  sudo systemctl start docker
  198  sudo systemctl enable docker
  199  sudo systemctl status docker
  200  docker --version
  201  docker pull hello-world
  202  sudo docker pull hello-world
  203  sudo docker pull busybox
  204  sudo docker pull ubuntu
  205  docker images
  206  sudo docker images
  207  sudo docker pull fedora
  208  sudo docker pull  mysql
  209  docker images
  210  sudo docker images
  211  docker run busybox
  212  sudo docker run busybox
  213  sudo docker run -it busybox sh
  214  docker run -d busybox
  215  sudo docker run -d busybox
  216  docker ps
  217  sudo docker ps
  218  clear
  219  docker run -dit --name fedora fedora
  220  sudo docker run -dit --name fedora fedora
  221  docker exec fedora ps -p 1
  222  exitdocker exec fedora ps -p 1
  223  sudo usermod -aG docker rusekdawid
  224  exit
  225  cd MDO2025_INO/
  226  ls
  227  docker exec fedora ps -p 1
  228  sudo docker exec fedora ps -p 1
  229  cd ..
  230  sudo docker exec fedora ps -p 1
  231  docker --version
  232  docker images
  233  sudo docker images
  234  docker run -d busybox
  235  sudo docker run -d busybox
  236  sudo docker ps
  237  git branch
  238  clear
  239  sudo docker run --tty busybox
  240  sudo docker run -d --name idk busybox tail -f /dev/null
  241  sudo docker exec -it idk sh
  242  sudo docker run -it --name system-container ubuntu /bin/bash
  243  sudo docker exec fedora ps -p 
  244  sudo docker exec fedora ps -p 1
  245  clear
  246  ps -p 1
  247  ps aux | grep docker
  248  apt update
  249  sudo docker run -it --name system-container ubuntu /bin/bash
  250  clear
  251  docker run busybox echo "
  252  elo"
  253  sudo docker run busybox echo "
  254  elo"
  255  sudo docker run -it busybox sh 
  256  ps aux | grep docker
  257  docker ps -a
  258  sudo docker ps -a
  259  sudo docker run -it fedora
  260  sudo docker run -it ubuntu
  261  clear
  262  sudo docker run  --tyy  busybox
  263  sudo docker run  --tty busybox
  264  sudo docker ps -a
  265  docker stop  $(docker ps -aq)
  266  sudo docker stop  $(docker ps -aq)
  267  docker rm $(docker ps -aq)
  268  sudo docker rm $(docker ps -aq)
  269  docker ps
  270  sudo docker ps -a
  271  sudo usermod -aG docker $USER
  272  groups
  273  docker ps
  274  exit
  275  docker rm $(docker ps -aq)
  276  docker ps
  277  docker stop $(docker ps -q)
  278  docker rm $(docker ps -aq)
  279  docker ps
  280  clear
  281  docker pull hello-world
  282  docker pull busybox
  283  docker pull ubuntu
  284  docker pull mysql
  285  sudo docker run --tty busybox
  286  [200~docker exec -it my_busybox sh~
  287  docker exec -it my_busybox sh
  288  sudo docker run -d --name my_busybox busybox  tail -f /dev/null
  289  docker exec -it my_busybox sh
  290  docker ps
  291  docker stop my_busybox
  292  docker ps
  293  docker stop my_busybox
  294  docker stop infallible_grothendieck
  295  docker ps
  296  docker run -it --name system-container ubuntu /bin/bash
  297  docker network inspect bridge
  298  sudo systemctl restart docker
  299  docker run -it --name system-container ubuntu /bin/bash
  300  docker ps
  301  docker rm system-container
  302  docker run -it --name system-container ubuntu /bin/bash
  303  ls
  304  cd MDO2025_INO/
  305  cd ITE/
  306  ls
  307  cd GCL06/
  308  ls
  309  cd DR416985/
  310  docker build -t moj_obraz
  311  docker build -t moj_obraz .
  312  docker run moj_obraz
  313  ls
  314  nano Dockerfile
  315  docker build -t fedora .
  316  nano Dockerfile
  317  docker build -t ubuntu .
  318  docker run ubuntu
  319  docker ps -a
  320  docker run -it ubuntu
  321  docker ps -a
  322  docker images
  323  docker stop $(docker ps -q)
  324  docker rm $(docker ps -aq)
  325  docker ps -a
  326  docker rmi $(docker images -q)
  327  docker images
  328* 
  329  docker images
  330  git add .
  331  git commit -m "DR416985"
  332  git push
  333  git push --set-upstream origin DR416985
  334  git push
  335  git push origin DR416985
  336  git pull origin DR416985
  337  git pull --rebase origin DR416985
  338  git push origin DR416985
  339  git push origin DR416985 --force
  340  git push
  341  git checkout
  342  git pull origin DR416985
  343  git status
  344  git add/rm report1.md
  345  git add report1.md
  346  git pull origin DR416985
  347  git pull --no-rebase origin DR416985
  348  git add .
  349  git commit -m "DR416985 e"
  350  git push origin DR416985 --force
  351  ls
  352  git push
  353  git push --set-upstream origin DR416985
  354  git push
  355  git checkout DR416985
  356  git branch
  357  git push
  358  ls
  359  cd screen
  360  ls
  361  cd ..
  362  git add .
  363  rm screen
  364  rm -rf screen
  365  ls
  366  cd lab2
  367  ls
  368  mkdir sc
  369  ls
  370  rm Dockerfile
  371  ls
  372  cd ..
  373  ls
  374  cd lab2
  375  ls
  376  history > historia_lab2.md
