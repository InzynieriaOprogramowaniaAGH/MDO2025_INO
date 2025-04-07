**Historia poleceń wyświetlona za pomoca  ```$ history```**

```bash
1  ls
2  ls -al
3  sudo dnf install openssh-server
4  ls -al
5  ssh-keygen -t ed25519 -C "wzacharski@example.com"
6  cat ~/.ssh/id_ed25519.pub
7  ssh-keygen -t ed25519 -C "wojzacharski@student.agh.edu.pl"
8  cat ~/.ssh/id_ed25519.pub
9  ssh -T git@github.com
10 git 
11 sudo dnf update -y
12 sudo dnf install git -y
13 git
14 git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO
15 git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git
16 ls
17 cd MDO2025_INO/
18 git status
19 git log -2
20 git branch 
21 ssh-keygen -t ed25519 -C "wojzacharski@student.agh.edu.pl" -f ~/.ssh/my_key_with_password
22 git status
23 git remote -v
24 git switch main 
25 git switch GCL08
26 GS
27 git status
28 git checkout -b WZ417828
29 git status
30 mkdir WZ417828
31 ls 
32 ls -al
33 cd .git/hooks/
34 cat .git/hooks/
35 ls -al
36 cat commit-msg.sample 
37 cd ..
38 ls
39 cd WZ417828/
40 touch commit-msg
41 chmod +x commit-msg 
42 cd ..
43 cd .git/hooks/
44 touch commit-msg
45 chmod +x commit-msg 
46 ls -al
47 code commit-msg
48 mv commit-msg MDO2025_INO/WZ417828
49 mv commit-msg /home/wzacharski/MDO2025_INO/WZ417828
50 cd /home/wzacharski/MDO2025_INO/WZ417828
51 ls -al
52 touch sprawozdanie.md
53 cd ..
54 mv WZ417828/ ITE/GCL08/
55 git status
56 git add ITE/GCL08/WZ417828/
57 git commit -m "WZ417828 Added git hook and sprawozdanie.md"
58 git config --global user.email "wojzach308@gmail.com"
59 git config --global user.name "Wojciech Zacharski"
60 git config --global user.email "wojzacharski@student.agh.edu.pl"
61 git commit -m "WZ417828 Added git hook and sprawozdanie.md"
62 git push origin WZ417828 
63 git origin -v
64 ls ~/.ssh
65 cat ~/.ssh/id_ed25519.pub
66 git config --global user.email "wojzach308@gmail.com"
67 cat ~/.ssh/id_ed25519.pub
68 git config --global user.name "WojZacharski"
69 cat ~/.ssh/id_ed25519.pub
70 git remote -v
71 ssh -T git@github.com
72 git status
73 git log
74 git log -2
75 git push origin WZ417828
76 ssh-keygen -t ed25519 -C "wojzach308@gmail.com"
77 cat ~/.ssh/id_ed25519.pub
78 git remote set-url origin git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git
79 ssh -T git@github.com
80 git push origin WZ417828
81 git branch -v
82 git log -2
83 sudo dnf install -y dnf-plugins-core
84 sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
85 sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
86 sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
87 sudo systemctl start docker
88 sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
89 sudo systemctl enable --now docker
90 sudo dnf install -y docker
91 sudo systemctl enable --now docker
92 sudo usermod -aG docker $USER
93 newgrp docker
94 docker --version
95 docker run hello-world
96 docker login
97 docker pull hello-world
98 docker pull busybox
99 docker pull ubuntu
100 docker pull fedora
101 docker pull mysql
102 docker run busybox echo "BusyBox dziala"
103 uname -a
104 ps
105 docker ps
106 docker run -it busybox sh
107 docker run busybox
108 docker run -it busybox sh
109 docker run -it ubuntu bash
110 ps aux | grep docker
111 ls
112 cd MDO2025_INO/
113 ls
114 cd ITE/
115 LS
116 ls
117 ls -a
118 git status
119 ls
120 cd GCL08/
121 ls
122 cd WZ
123 cd WZ417828/
124 ls
125 touch Dockerfile
126 code Dockerfile 
127 docker build -t moj_obraz .
128 s -al
129 docker build -t moj_obraz .
130 docker build -t fedora_git .
131 docker build -t fedora_git .\
132 docker build -t fedora_git .
133 docker run -it fedora_git
134 docekr ps
135 docker ps
136 ls
137 git status
138 git add Sprawozdanie1/
139 git commit -m "WZ417828 Dockerfile"
140 git push origin WZ417828 
141 ls
142 dnf install -y gcc make
143 sudo dnf install -y gcc make
144 ls
145 cd redis/
146 ls
147 make
148 sudo dnf install -y jemalloc jemalloc-devel
149 make
150 sudo dnf update
151 make
152 sudo dnf install -y jemalloc jemalloc-devel
153 make
154 sudo dnf install meson
155 cd ..
156 cd irssi/
157 ls
158 meson build
159 sudo dnf install cmake
160 meson build
161 sudo dnf groupinstall "Development Tools"
162 sudo dnf install -y glib2-devel
163 meson build
164 meson setup build
165 sudo dnf install ncurses-devel
166 sudo dnf install utf8proc-devel ncurses-devel
167 meson setup build
168 meson build
169 sudo dnf install perl-ExtUtils-Embed
170 meson build
171 meson Build
172 ninja -C Build && sudo ninja -C Build install
173 ls
174 cd tests/
175 ls -al
176 cd ..
177 cd redis/
178 ls
179 make
180 make USE_JEMALLOC=yes
181 make distclean
182 make USE_JEMALLOC=yes
183 cd ..
184 ls
185 cd redis/
186 cd ..
187 git clone https://github.com/DaveGamble/cJSON.git
188 cd cJSON/
189 make
190 ls
191 make tests
192 ls test
193 cd tests/
194 ls -al
195 cd ..
196 make tests
197 make test
198 docker run -it fedora:latest /bin/bash
199 ls
200 cd.. 
201 cd ..
202 ls
203 cd MDO2025_INO/ITE/GCL08/WZ417828/Lab\ 3/
204 cd ..
205 cd Lab3/
206 docker build -t cjson_build -f Dockerfile_build .
207 docker build -t cjson_test -f Dockerfile_test . 
208 docker run cjson_test
209 docker build -t cjson_test -f Dockerfile_test . 
210 docker run cjson_test
211 ls
212 cd ..
213 ls
214 cd ..
215 ls
216 git status
217 cd ITE/
218 ls
219 cd GCL08/
220 ls
221 cd WZ417828/
222 git status
223 git tatuws
224 git status
225 git add .
226 git status
227 git commit -m "WZ417828 dockerfile for cJSON" 
228 git status
229 git push origin WZ417828 
230 ls
231 docker run --rm -v vol_input:/app/input alpine   sh -c "apk add git && git clone https://github.com/DaveGamble/cJSON.git /app/input"
232 docker run -it --rm --network container:iperf-server fedora   sh -c "dnf install -y iperf3 && iperf3 -c 127.0.0.1"
233 docker network create --driver bridge siec
234 docker run -it --rm --network siec --name iperf-server fedora   sh -c "dnf install -y iperf3 && iperf3 -s"
235 docker run -it --rm -p 5201:5201 --name iperf-server fedora   sh -c "dnf install -y iperf3 && iperf3 -s"
236 git status
237 ls
238 cd MDO2025_INO/
239 ls
240 git status
241 git add .
242 git status
243 git commit -m "WZ417828 Sprawozdanie1"
244 git log -3
245 cat ~/.bash_history
246 ~/.bash_history
247 history
```
