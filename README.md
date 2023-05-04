# vmware_ansible_examples
If you do not have an ansible environment, you could use my docker container to run and mess around with ansible.
The benefit with having ansible in the container is so that all your packages are version controlled, and you know it works. 
The container is then portable, and it can be installed anywhere! Just make sure docker is installed.

The following command is an example
- ensure to replace "/docker/files" with a local directory on the docker host, here I tend to keep my files such as OVAs and ISOs.
- ensure to replace "/docker/vmware_ansbile_examples" with a local directory on the docker host, this is the folder which contains your ansible code.
- You will bash into the container and will find your mounted folders in /mnt/

#### Example command
```
docker run --privileged -it --tty --rm \
-v /docker/files:/mnt/files \
-v /docker/vmware_ansible_examples:/mnt/ansible_playbooks \
harrythambi/hlb_base_container:0.1 bash
```