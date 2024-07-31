role=$1

hostname
uname
exit
ansible-playbook get-secrets.yml -e vault_token=$vault_token -e env=$env -e role=$role
aws ec2 describe-instances --filters Name=tag:Name,Values=$role-$env Name=instance-state-name,Values=running --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text >inv
ansible-playbook -i inv -e env=$env -e role=$role ansible.yml -e '@~/secrets.json'
hostname
#rm -f ~/*.json