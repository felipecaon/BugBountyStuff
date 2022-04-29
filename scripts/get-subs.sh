echo ">> Getting Subdomains..."

amass enum -d $1 -o amass_$1.txt > /dev/null 2>&1
echo "[+] Amass done"

subfinder -silent -d $1 > subfinder_$1.txt
echo "[+] Subfinder done"

findomain -t $1 -q > findomain_$1.txt
echo "[+] Findomain done"

gau --subs $1 | unfurl -u domains > gau_$1.txt
echo "[+] Gau subdomains done"

assetfinder -subs-only $1 > assetfinder_$1.txt
echo "[+] Assetfinder done"

cat amass_$1.txt subfinder_$1.txt findomain_$1.txt gau_$1.txt assetfinder_$1.txt | anew subdomains
rm amass_$1.txt subfinder_$1.txt findomain_$1.txt gau_$1.txt assetfinder_$1.txt

