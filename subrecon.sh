#!/bin/bash
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"

newline(){
	echo ""
}

startScript(){
	echo -e "${RED}[+] Running $1...${RESET}"
}

startSection(){
    newline
	echo -e "${GREEN} = $1 =${RESET}"
}

BASE='/opt/listas'
TOOLS=~/Documents/recon/toolz

# Subdomain enumeration
startSection "Starting subdomain enumeration"
echo -e "${YELLOW}Target: $1${RESET}"

SUBDOMAINS=$1_subdomains.txt
SUBFINDER=subfinder_$1.txt
ASSETFINDER=assetfinder_$1.txt
GITHUB_SUBDOMAINS=github_$1.txt
FINDOMAIN=findomain_$1.txt

startScript "Subfinder"
subfinder -silent -d $1 | tee -a $SUBFINDER

startScript "Assetfinder"
assetfinder --subs-only $1 | tee -a $ASSETFINDER

startScript "Subdomain scanning on github"
python3 $TOOLS/githubffff-subdomains.py -d $1 | anew $GITHUB_SUBDOMAINS

startScript "Findomain"
findomain -q -t $1 | tee -a $FINDOMAIN

cat $SUBFINDER | anew $SUBDOMAINS
cat $ASSETFINDER | anew $SUBDOMAINS
cat $GITHUB_SUBDOMAINS | anew $SUBDOMAINS
cat $FINDOMAIN | anew $SUBDOMAINS

rm $SUBFINDER
rm $ASSETFINDER
rm $GITHUB_SUBDOMAINS
rm $FINDOMAIN

# generating commonspeak list
startSection "Starting subdomain generation"
SUBS_PLUS_COMMONSPEAK=all_subdomains.txt
COMMONSPEAK=commonspeak.txt
python3 $TOOLS/joiner.py $1 | anew $COMMONSPEAK
cat $SUBDOMAINS $COMMONSPEAK | anew $SUBS_PLUS_COMMONSPEAK

# Firing up massdns
startSection "Starting masscan"
FINAL_MASSDNS=final_massdns.txt
MASSDNS=$TOOLS/massdns/bin/massdns
RESOLVERS=$BASE/resolvers.txt
FIRST_MASSDNS_OUTPUT=first_massdns_output.txt
cat $SUBS_PLUS_COMMONSPEAK | $MASSDNS -r $RESOLVERS -t A -o S -w $FIRST_MASSDNS_OUTPUT
cat $FIRST_MASSDNS_OUTPUT | awk '{print $3}' | anew ips.txt
cat $FIRST_MASSDNS_OUTPUT | sed 's/CN.*\|A.*//' | sed 's/\..$//' | anew $FINAL_MASSDNS

rm $FIRST_MASSDNS_OUTPUT

# find alive domanins
startSection "Veryfing alive subdomains"
VALID_DOMAINS=valid.txt
cat $FINAL_MASSDNS | httpx -silent | anew $VALID_DOMAINS

# pegar ips

#check CNAMES
startScript "Get CNAMES"
CNAMES_MASSDNS=cnames_massdns.txt
cat $FINAL_MASSDNS | $MASSDNS -r $RESOLVERS -t CNAME -o S -w $CNAMES_MASSDNS

#checking for takeover
startSection "Checking for takeovers"
cat $CNAMES_MASSDNS | sed 's/CN.*\|A.*//' | sed 's/\..$//' | anew withcnames.txt
subjack -c $TOOLS/fingerprints.json -w withcnames.txt -m -a | anew subjack.txt

#s3 scanner
startSection "Finding s3 buckets"
s3scanner --threads 10 scan -f $FINAL_MASSDNS | anew buckets.txt

# fff
startSection "Running fff from working domains"
cat $VALID_DOMAINS | fff -S -o roots/

# Download js from valid domains sources
startSection "Download js from valid domains sources"
$TOOLS/getjsfromsource.sh roots

# eyewitness
startScript "Screenshot it all"
python3 $TOOLS/eyewitness/Python/EyeWitness.py -f $VALID_DOMAINS --no-prompt -d screenshots --web

# gau
startSection "Running gau"
cat $VALID_DOMAINS | gauplus -t 20 | anew gau.txt

#  get js from gau
startScript "Download JS files from gau output"
cat gau.txt | grep -iE "\.js" | anti-burl | awk '{print $4}' | anew gauvalidjs.txt
cat gauvalidjs.txt | fff -S -o jsfiles/gau
rm gauvalidjs.txt

#  get paramters from gau
startScript "Get a list of urls with params"
cat gau.txt | grep "=" | anti-burl | awk '{print $4}' | anew paramterers.txt

# intesresting files from gau
startScript "Whats interesting in here"
cat gau.txt | grep -iEv '(\.pdf|\.swf|\.txt|\.conf|\.xml|\.php\|\.sql|\.doc|\.ppt|\.json)' | anew interesting.txt

#open redirect one liner
# export LHOST="http://localhost"; gau $1 | gf redirect | qsreplace "$LHOST" | xargs -I % -P 25 sh -c 'curl -Is "%" 2>&1 | grep -q "Location: $LHOST" && echo "VULN! %"'

#xss gxss/kxss + arjun dalfox
# cat gau | grep "=" | xargs | dalfox -arjun

# waf bypass
# https://pentestbook.six2dez.com/enumeration/web/header-injections
# X-Originating-IP: 127.0.0.1
# X-Forwarded-For: 127.0.0.1 #header injection
# X-Remote-IP: 127.0.0.1
# X-Remote-Addr: 127.0.0.1

#ssrf xsshunter

#lfi rce