![alt text](image.png)

![alt text](image-1.png)

![alt text](image-2.png)

PPM i "Punkt kontrolny"

![alt text](image-3.png)

PPM i "Eksportuj"

![alt text](image-4.png)

![alt text](image-14.png)

![alt text](image-15.png)

![alt text](image-16.png)

![alt text](image-17.png)

![alt text](image-9.png)

Na dwoch maszynach

![alt text](image-10.png)

![alt text](image-11.png)

![alt text](image-12.png)

![alt text](image-19.png)

![alt text](image-18.png)

```yaml
- name: Ping all hosts
  hosts: all
  gather_facts: no
  tasks:
    - name: Ping
      ansible.builtin.ping:
```

![alt text](image-20.png)

![alt text](image-21.png)

Dodac w inventory.ini ansible_user i ansible_become_password
lub
--ask-become-pass

![alt text](image-22.png)

```
[Orchestrators]
ansible-main ansible_user=michals ansible_become_pass=123

[Endpoints]
ansible-target ansible_user=ansible ansible_become_pass=ansible
```
![alt text](image-24.png)

![alt text](image-25.png)

![alt text](image-26.png)