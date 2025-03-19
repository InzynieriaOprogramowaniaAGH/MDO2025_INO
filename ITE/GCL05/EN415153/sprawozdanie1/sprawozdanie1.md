![ss1](ss/Screenshot1.png)
![ss2](ss/Screenshot2.png)
![ss3](ss/Screenshot3.png)
![ss4](ss/Screenshot4.png)
![ss5](ss/Screenshot5.png)
![ss6](ss/Screenshot6.png)
![ss7](ss/Screenshot7.png)
![ss8](ss/Screenshot8.png)
![ss9](ss/Screenshot9.png)
![ss10](ss/Screenshot10.png)
![ss11](ss/Screenshot11.png)
![ss12](ss/Screenshot12.png)
![ss13](ss/Screenshot13.png)
![ss14](ss/Screenshot14.png)
![ss15](ss/Screenshot15.png)
![ss16](ss/Screenshot16.png)
![ss17](ss/Screenshot17.png)

```bash
#!/bin/bash

PREFIX="EN415153"
COMMIT_MSG_FILE="$1"
FIRST_LINE=$(head -n 1 "$COMMIT_MSG_FILE")

if [[ ! "$FIRST_LINE" =~ ^"$PREFIX" ]]; then
    echo "Commit musi zaczynac sie od: '$PREFIX'"
    exit 1
fi

exit 0
```

![ss18](ss/Screenshot18.png)
![ss19](ss/Screenshot19.png)
![ss20](ss/Screenshot20.png)
![ss21](ss/Screenshot21.png)
![ss22](ss/Screenshot22.png)



![ss23](ss/Screenshot23.png)
![ss24](ss/Screenshot24.png)
![ss25](ss/Screenshot25.png)
![ss26](ss/Screenshot26.png)
![ss27](ss/Screenshot27.png)
![ss28](ss/Screenshot28.png)
![ss29](ss/Screenshot29.png)
![ss30](ss/Screenshot30.png)


```bash
FROM fedora:latest
RUN dnf update -y && dnf install -y git
WORKDIR /app
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO.git .
CMD ["/bin/bash"]
```

![ss31](ss/Screenshot31.png)
![ss32](ss/Screenshot32.png)
![ss33](ss/Screenshot33.png)
![ss34](ss/Screenshot34.png)