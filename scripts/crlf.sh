echo "[+] Testing for crlf..."

cat $1 | crlfuzz -o crlf.txt
