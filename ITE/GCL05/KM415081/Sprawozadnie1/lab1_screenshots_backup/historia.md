1  dnf update -y
    2  systemctl enable sshd
    3  systemctl start sshd
    4  systemctl status sshd
    5  ip a
    6  sshd enable
    7  systemctl enable sshd
    8  systemctl start sshd
    9  systemctl status sshd
   10  ssh cadmus@192.168.1.2
   11  ls -l /home
   12  ip a
   13  scp test.txt student@192.168.56.101:/home/student/
   14  scp test.txt student@192.168.56.101:/home/
   15  scp test.txt student@192.168.56.101:/C:/Users/cadmus/Desktop/
   16  scp -P 2222 "C:\Users\cadmus\Desktop\test.txt" cadmus@127.0.0.1:~
   17  scp test.txt student@192.168.56.101:"C:\Users\cadmus\Desktop\test.txt"
   18  cd C:\Users\cadmus\Desktop
   19  dir C:\Users\cadmus\Desktop\test.txt
   20  ls
   21  dir C:\Users\cadmus\Desktop\test.txt
   22  scp C:\Users\cadmus\Desktop\test.txt cadmus@192.168.1.2:/home
   23  scp C:\Users\cadmus\Desktop\test.txt cadmus@10.0.2.15:/home
   24  ssh cadmus@10.0.2.15
   25  scp C:\Users\cadmus\Desktop\test.txt cadmus@10.0.2.15:/home/
   26  scp C:/Users/cadmus/Desktop/test.txt cadmus@10.0.2.15:/home/
   27  scp "C:\Users\cadmus\Desktop\test.txt" cadmus@10.0.2.15:/home/
   28  systemctl enable sshd
   29  systemctl start sshd
   30  systemctl status sshd
   31  ip a
   32  sudo systemctl status sshd
   33  ss -tln
   34  sudo ufw status
   35  sudo ufw allow 22/tcp
   36  systemctl enable ssh
   37  systemctl start sshd
   38  systemctl status sshd
   39  ip a
   40  scp C:\Users\cadmus\Desktop\test.txt cadmus@127.0.0.1:/home/cadmus/
   41  scp -P 2222 C:\Users\cadmus\Desktop\test.txt cadmus@127.0.0.1:/home/cadmus/
   42  scp -P 2222 C:\Users\cadmus\Desktop\test.txt cadmus@10.0.2.15:/home/cadmus/
   43  scp -P 2222 C:\Users\cadmus\Desktop\test.txt cadmus@localhost:/home/cadmus/
   44  systemctl enable sshd
   45  systemctl start sshd
   46  systemctl status sshd
   47  ip a
   48  sudo systemctl status ssh
   49  systemctl status sshd
   50  ss -tln
   51  ip a
   52  hostname -I
   53  systemctl status sshd
   54  sudo dnf install openssh-server -y
   55  sudo firewall-cmd --add-service=ssh --permanent
   56  sudo firewall_cmd --reload
   57  sudo firewall-cmd --reload
   58  sudo netstat -tlnp | grep :22
   59  cd home/cadmus
   60  ls
   61  ls ~/.ssh/id_tsa.pub
   62  ssh-keygen -t rsa -b 4096 -C "mierzwakc@o2.pl"
   63  ls ~/.ssh/id_tsa.pub
   64  cat ~/.ssh/id_rsa.pub
   65  cat ~/.ssh/id_rsa.pub > my_key.txt
   66  scp -P 2222 cadmus@127.0.0.1:my_key.txt C:\Users\cadmus\Desktop\
   67  ls
   68  scp -P 22 cadmus@127.0.0.1:my_key.txt C:\Users\cadmus\Desktop\
   69  sudo apt update && sudo apt install virtualbox-guest-utils -y
   70  sudo apt install
   71  sudo dnf install virtualbox-guest-additions -y
   72  ls
   73  cat ~/.ssh/id_rsa.pub > my_key.txt
   74  cat ~/.ssh/id_rsa.pub
   75  ssh -T git@github.com
   76  git clone git@github.com:cadmusinho/yo.git
   77  sudo dnf install git -y
   78  git clone git@github.com:cadmusinho/yo.git
   79  ls
   80  cat my_key.txt
   81  git clone git@github.com:kamiljdudek/MDO2025_INO.git
   82  systemctl enable sshd
   83  systemctl start sshd
   84  systemctl status sshd
   85  ip a
   86  exit
   87  git --version
   88  git clone https://github.com/InzynieriaOprogramowaniaAGH?MDO2025_INO.git
   89  git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
   90  ls
   91  ls
   92  mkdir -p ~/.ssh && cd ~/.ssh
   93  ls
   94  ssh-keygen -t ed25519 -C "twojemail@example.com"
   95  ssh-keygen -t ed25519 -C mierzwakc@o2.com"
   96  25wajfzyUP
   97  ls
   98  cat id_rsa
   99  cat known_hosts
  100  ssh-keygen -t ed25519 -C "mierzwakc@o2.com"
  101  ssh-keygen -p -f ~/.ssh/id_ed25519
  102  ssh-keygen -t ecdsa -b 521 -C "mierzwakc@o2.com"
  103  eval "$(ssh-agent -s)"
  104  ssh-add ~/.ssh/id_ed25519
  105  cat ~/.ssh/id_ed25519.pub
  106  ssh -T git@github.com
  107  git clone git@github.com:kamiljdudek/MDO2025_INO.git
  108  git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
  109  git checkout main
  110  cd ~/MDO2025_INO
  111  git checkout main
  112  git checkout GCL05
  113  git checkout -b KM415081
  114  exit
  115  systemctl status sshd
  116  exit
  117  systemctl status sshd
  118  ip -a
  119  ip
  120  exit
  121  ls
  122  git checkout GCL05
  123  cd MDO2025_INO/
  124  git checkout GCL05
  125  git pull origin GCL05
  126  git branch -a
  127  git checkout GCL05
  128  git branch
  129  git checkout main
  130  git checkout GCL05
  131  git branch
  132  git log --oneline --graph --decorate --all
  133  git checkout KM415081
  134  mkdir GCL05/KM415081
  135  mkdir KM415081
  136  ls GCL05/
  137  ls
  138  rmdir KM415081
  139  ls
  140  cd..
  141  cd ..
  142  ls
  143  cd MDO2025_INO/
  144  ls
  145  git checkout KM415081
  146  mkdir GCL05/KM415081
  147  ls -l
  148  git checkout KM415081
  149  mkdir -p GCL05/KM415081
  150  cd .git/hooks
  151  nano commit-msg
  152  chmod +x commit-msg
  153  cp commit-msg ../../GCL05/KM415081/
  154  cp ../../GCL05/KM415081/commit-msg .git/hooks/
  155  nano commit-msg
  156  cp KD232144/pre-commit .git/hooks/pre-commit
  157  cd ~/MDO2025_INO
  158  ls .git/hooks
  159  ls -l ../../GCL05/KM415081/commit-msg
  160  ls -l ../../GCL05/KM415081/
  161  ls -l ../../GCL05/
  162  nano ../../GCL05/KM415081/commit-msg
  163  ls -l ../../GCL05/KM415081/
  164  ls
  165  cd GCL05
  166  ls
  167  nano KD232144/pre-commit
  168  git checkout KM415081
  169  nano .git/hooks/commit-msg
  170  ls .git/hooks/
  171  chmod +x .git/hooks/commit-msg
  172  git rev-parse --is-inside-work-tree
  173  ls
  174  cd KM415081/
  175  ls
  176  nano commit-msg 
  177  mv KM415081/commit-msg .git/hooks/
  178  mv commit-msg ../.git/hooks/
  179  cd ~/MDO2025_INO/GCL05
  180  ls -a
  181  ls
  182  pwd
  183  ls -a ~/MDO2025_INO/
  184  cd ~/MDO2025_INO/
  185  git init
  186  mkdir .git/hooks
  187  mv KM415081/commit-msg .git/hooks/
  188  pwd
  189  ls -a KM415081
  190  find ~ -type d -name "KM415081"
  191  cd ~/MDO2025_INO/GCL05/KM415081
  192  ls
  193  cd ~/MDO2025_INO/GCL05
  194  mv KM415081/commit-msg .git/hooks/
  195  git checkout KM415081
  196  ls
  197  cd KM415081/
  198  ls
  199  nano commit-msg 
  200  cd ..
  201  ls
  202  cd .git/hooks
  203  ls
  204  cat commit-msg
  205  cat commit-msg.sample
  206  nano commit-msg
  207  chmod +x commit-msg
  208  cd ..
  209  ls
  210  cd ..
  211  ls
  212  cd GCL05
  213  ls
  214  cd KM415081/
  215  ls
  216  cd ..
  217  cd ITE
  218  ls
  219  cd ..
  220  rmdir -r GCL05
  221  rmdir GCL05
  222  rmdir --r GCL05
  223  rm -r GCL05
  224  ls
  225  cd ITE
  226  ls
  227  cd GCL05
  228  ls
  229  mkdir KM415081
  230  nano commit-msg
  231  ls
  232  mv commit-msg ./KM415081/
  233  ls
  234  cd KM415081/
  235  ls
  236  mkdir Sprawozadnie1
  237  cd Sprawozadnie1/
  238  touch README.md
  239  ls
  240  nano README.md
  241  git branch
  242  cd ..
  243  git add .
  244  git status
  245  git commit -m "init"
  246  git commit -m "KM415081 pierwszy commicik"
  247  git push origin KM415081
  248  ls
  249  cd ..
  250  ls
  251  cd ..
  252  ls
  253  cd ..
  254  ls
  255  cd ..
  256  ls
  257  git branch
  258  cd MDO2025_INO/
  259  git branch
  260  ls
  261  cd ITE
  262  history
  263  cd ..
  264  git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
  265  ls
  266  git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
  267  ls
  268  cd MDO2025_INO/
  269  git checkout main
  270  git checkout GCL05
  271  ls
  272  cd ITE
  273  ls
  274  cd GCL05
  275  ls
  276  git checkout main
  277  git checkout KM415081
  278  ls
  279  cd KM415081/
  280  ls
  281  pwd
  282  ls
  283  nano commit-msg
  284  cd .git/hooks/
  285  cd ..
  286  cd .git/hooks/
  287  ls
  288  git branch
  289  cd ..
  290  ls
  291  cd ..
  292  ls
  293  cd ITE
  294  ls
  295  cd GCL05
  296  ls
  297  cd KM415081/
  298  ls
  299  cd Sprawozadnie1/
  300  ls
  301  git branch
  302  mkdir lab1_screenshots
  303  ls
  304  cp C:\Users\cadmus\Desktop\images\*.png lab1_screenshots/
  305  cp "C:\Users\cadmus\Desktop\images\*.png" lab1_screenshots\
  306  cp 'c:/Users/cadmus/Desktop/images' lab1_screenshots/
  307  /mnt/c/Users/cadmus/Desktop/images/
  308  scp C:\Users\cadmus\Desktop\images\*.png cadmus@127.0.0.1:/home/cadmus/fotos1
  309  scp "C:\Users\cadmus\Desktop\images\*.png" cadmus@127.0.0.1:/home/cadmus/fotos1/
  310  ls
  311  cd lab1_screenshots/
  312  ls
  313  cd ..
  314  rm lab1_screenshots/
  315  rmdir lab1_screenshots/
  316  ls
  317  mkdir lab1_screenshots
  318  ls
  319  rmdir lab1_screenshots/
  320  ls
  321  mkdir lab1_screenshots
  322  git branch
  323  git add .
  324  git status
  325  cd lab1_screenshots/
  326  git branch
  327  git add .
  328  git status
  329  git commit -m "test"
  330  touch historia.md
  331  ls
  332  nano historia.md 
  333  history
