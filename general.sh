dir=~/workflow

echo "[+] Starting Scan"

# Get Subdomains
$dir/get-subs.sh $1;

# Get historic urls with gau
$dir/gau.sh $1

# Port scan and probing
$dir/ports-probe.sh subdomains

# Crawl
$dir/crawl.sh probed/httpx_domains_only.txt

# nuclei
$dir/nuclei.sh probed/httpx_domains_only.txt

# smuggling
$dir/smuggling.sh probed/httpx_domains_only.txt

#crlf
$dir/crlf.sh probed/httpx_domains_only.txt

# ffuf?
