# $1 list with domains
# $2 list with resolvers

puredns resolve $1 -r $2 --wildcard-tests 8 --write resolved_dns_domains --write-massdns massdns_like

# Verify alive
cat resolved_dns_domains | httpx -silent | anew valid_domains