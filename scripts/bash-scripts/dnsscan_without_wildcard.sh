# $1 list with domains
# $2 list with resolvers

cat $1 | massdns -r $2 -o S -w massdns_output
cat massdns_output | awk '{print $3}' | anew ips
cat massdns_output | grep  -w "A" | awk '{print $1}' | sed 's/\.$//' | tr A-Z a-z | anew resolved_dns_domains
cat massdns_output | grep -w "CNAME" | awk '{print $1}' | sed 's/\.$//' | anew cnames
rm massdns_output
