# Ansible Notes

sudo apt install ansible -y

 Home Ansible on WSL
 pip3 install ansible --upgrade --user (not as root)
 pip3 uninstall ansible ansible-base

 https://galaxy.ansible.com
 https://docs.ansible.com
 https://docs.ansible.com/ansible/latest/collections/index.html

## Ping

     ansible example -m ping -u jay

## Update and Upgrade - UbuntuBased

note: this playbook WILL reboot the server if required

     ansible-playbook update.yml -vv

Parameters:

-K  - Ask for password
