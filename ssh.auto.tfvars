ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCkPIUR7/oEMTIw6iX9+Q3rzvYlrAM3vBq9yahePL1aGklC9DYXpkyfHfggK9YMlhlMnFcd7rA4MAivHMy386pVLDUWIlqgkPBd/q6FVglwFuits4OqVYjiR9ldfSdc2tfCknz6YQ3jzBV36k/vhMwISqchKMEO3wAG0mxAWfec8MP7UT4TA9V16A/g7nVCtqi5AaxlbqRAxPF6RAcrT5yI3KmNRrq6d9ifBcmmZU2dGm4xNZOuav9LQZijDmNqatDqwZzAfuoGEug5kP2jfmv72LQnmjwDNI+bk4cfaCoBf/+2DVKovs/gOXJu2N0f44AsgsrMh3V3A8bUa4MknP6DyOeUfDHc7XFHORH9zpu/wS+JdtCVQ0DwXJ/c/G/en+hgk9liZ1gWK2D9ZK8C4wrrfcrGHYxTrW8d5pABJOGsLuADSl6fJ+FchFTkZyBKWDRmeAel3EhT6PLXtTVy+fIP5Licrj4KmsR9JhIHQVDxaMRqXEtyXW7MYi55rjt/KBmp4pJCi63jpagcBqwWpuSaf/ZQRSobNNISguaCpizQOWUK0dG1gjnXxzBiRE3BDsv56i6+GHCVLf8VDVEZtH20mNrN5JfH5I7dXHSLL9E2ca1Bt4fz8bRPn/sr4Nxx8QrkFdAEZeOsUnHxLSsThaCT5HA3rCgnvqu+cT4LX5+gPw== jamesd@hageman.ca"

# when switching wifi, you can find your public ip with this command:
#   curl -s ifconfig.me
local_public_ip_address = "99.250.152.123"

# when moving geographically, change the region for lower latency.
#   $ curl -s -u $TOKEN: https://api.digitalocean.com/v2/regions | jq -r '.regions[] | .name + "\t" + .slug' | sort
#   Amsterdam 3	ams3
#   Bangalore 1	blr1
#   Frankfurt 1	fra1
#   London 1	lon1
#   New York 1	nyc1
#   New York 3	nyc3
#   San Francisco 2	sfo2
#   Singapore 1	sgp1
#   Toronto 1	tor1
region = "tor1"
