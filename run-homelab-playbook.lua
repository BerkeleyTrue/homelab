#!/bin/lua

-- run omv lab commands
os.execute('ansible-playbook -i hosts.yml omv.yml')
