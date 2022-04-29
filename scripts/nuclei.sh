echo "[+] Running Nuclei..."

cat $1 | nuclei -severity 'low,medium,high,critical' >> nuclei.txt
