# get_subdomains [domain]

# Subdomain enumeration
SUBDOMAINS=$1_subdomains.txt
SUBFINDER=subfinder_$1.txt
ASSETFINDER=assetfinder_$1.txt
GITHUB_SUBDOMAINS=github_$1.txt
FINDOMAIN=findomain_$1.txt

echo "Running subfinder"
subfinder -silent -d $1 | anew $SUBFINDER

echo "Running assetfinder"
assetfinder --subs-only $1 | anew $ASSETFINDER

echo "Running github-subdomains"
github-subdomains.py -d $1 | anew $GITHUB_SUBDOMAINS

echo "findomain"
findomain -q -t $1 | anew $FINDOMAIN

cat $SUBFINDER $ASSETFINDER $GITHUB_SUBDOMAINS $FINDOMAIN | anew $SUBDOMAINS

rm $SUBFINDER
rm $ASSETFINDER
rm $GITHUB_SUBDOMAINS
rm $FINDOMAIN