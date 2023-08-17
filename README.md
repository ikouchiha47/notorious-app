# README

Required:
- ruby > 3.1
- nginx
- python3 & ansible (scripts for setup provided)
- certbot (installed either via apt or snap or use ansible)
- ufw (firewalls)
- docker & docker-compose (for setting up database)

### Running service:
- `docker compose up -f ./infrafiles/db.compose.yaml -d`
- `./bin/rake db:setup` (involves, create and seed)
- `./bin/rails s`


### Running setup

Bootstrapping for setup:
- `python3 -m .venv venv`
- `bash ./setup_ansible.sh` (follow instructions)

This will also create a `vars.yml`, which will be encrypted with the provided password.

A sample has been provided in `sample.vars.yml`. Edit the `vars.yml` and add the config as such:
- `ansible-vault edit vars.yaml`
- copy the config from sample and put it in here, with appropriate values

Setup api gateway and certbot for ssl with letsencrypt:
- `bash ./run_ansible.sh ./playbooks/nginx_setup.yaml`
- `bash ./run_ansible.sh ./playbooks/ssl_certificates.yaml`

Setting firewall rules:
- `bash ./setup_firewall.sh`


### Checklist:
- `sudo ufw status numbered` should show valid rules and should be enabled
- `sudo ip addr show` should give proper ipv6 ip which is accessible via internet (scope global dynamic noprefixroute)
- `dig https://mr-notorious.shop` domain name should be pointing to your machine (where server is running)
- `sudo nginx -t` to validate the configuration
- `sudo systemctl restart nginx` to restart before starting to serve

