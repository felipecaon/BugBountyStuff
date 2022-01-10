echo $1

subfinder -silent -d $1 -o subfinder_$1.txt &>/dev/null
echo "[+] Subfinder finalizado"

findomain -t $1 -u findomain_$1.txt &>/dev/null
echo "[+] Findomain finalizado"

github-subdomains -d $1 -o github_$1.txt &>/dev/null
echo "[+] Github subdomains finalizado"

cat subfinder_$1.txt findomain_$1.txt github_$1.txt | anew not_resolved_$1_subdomains
echo "$1" >> not_resolved_$1_subdomains
echo "www.$1" >> not_resolved_$1_subdomains
cat not_resolved_$1_subdomains | httpx --tech-detect | tee -a tech_detect
rm subfinder_$1.txt findomain_$1.txt github_$1.txt
cat tech_detect | awk '{print $1}' >> valid_domains

