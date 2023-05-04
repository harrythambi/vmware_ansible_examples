## Example to start an interactive BASH session with mounted directories containing files and ansible playbooks
```
docker run --privileged -it --tty --rm \
-v /docker/files:/mnt/files \
-v /docker/vmware_ansible_examples:/mnt/ansible_playbooks \
harrythambi/hlb_base_container:0.1 bash
```

## Example RUN ansible playbooks from outside of the container with mounted directories containing files and ansible playbooks
```
docker run --privileged --tty --rm \
-v /docker/files:/mnt/files \
-v /docker/Repos/vmware_ansible_examples:/mnt/ansible_playbooks \
harrythambi/hlb_base_container:0.1 \
ansible-playbook /mnt/ansible_playbooks/demo_1_deploy_appliance_part1.yaml \
-i /mnt/ansible_playbooks/inventory/demo_1.yaml \
--tags 'all'
```

## Demo 1 - Part 1 - Playbook Tasks - Deploying NSX-T Manager appliance
```
ansible-playbook /mnt/ansible_playbooks/demo_1_deploy_appliance_part1.yaml
```

## Demo 1 - Part 2 - Playbook Tasks with Inventory - Deploying NSX-T Manager appliance
```
ansible-playbook -i /mnt/ansible_playbooks/inventory/demo_1.yaml /mnt/ansible_playbooks/demo_1_deploy_appliance_part2.yaml 
```

## Demo 1 - Part 3 - Playbook Roles with Inventory - Deploying NSX-T Manager appliance
```
ansible-playbook -i /mnt/ansible_playbooks/inventory/demo_1.yaml /mnt/ansible_playbooks/demo_1_deploy_appliance_part3.yaml 
```

## Demo 2 - Playbook Roles with Inventory - Configuring already deployed vcenter and esxi hosts
```
ansible-playbook -i /mnt/ansible_playbooks/inventory/demo_2.yaml /mnt/ansible_playbooks/demo_2_configure_vcsa_esxi.yaml 
```

## Demo 3 - Playbook Roles with Inventory - Configuring MSXT DHCP Profile, Tier1 and Segments
```
ansible-playbook -i /mnt/ansible_playbooks/inventory/demo_3.yaml /mnt/ansible_playbooks/demo_3_configure_nsxt_tenant_networking.yaml 
```