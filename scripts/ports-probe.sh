echo "[+] Probing..."

mkdir probed

cat $1 | naabu -top-ports 5000 -exclude-ports 22,80,443,8080,8443 >> probed/ports_$1.txt
echo "[+] Naabu done"

cat $1 | httpx -nf --title --tech-detect --status-code >> probed/httpx_$1.txt
echo "[+] httpx done"

cat probed/ports_$1.txt | httpx -nf --title --tech-detect --status-code >> probed/httpx_ports_$1.txt
echo "[+] httpx ports done"

cat $1 | dnsx -silent -a -cname -resp >> probed/cnames.txt
echo "[+] dnsx done"

cat probed/httpx_$1.txt | awk '{print $1}'  >> probed/httpx_domains_only.txt
