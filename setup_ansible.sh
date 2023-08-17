#/bin/bash


python3 -m venv .venv
echo "activate the env with source .venv/bin/activate[.shell]"
echo "and comment the line below"

# comment/uncomment this
# exit 1;

python3 -m pip install ansible
ansible-vault create vars.yml
