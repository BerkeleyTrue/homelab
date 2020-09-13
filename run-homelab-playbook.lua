#!/bin/lua

-- run home lab commands
os.execute('ansible-playbook -i hosts.yml omv.yml')
