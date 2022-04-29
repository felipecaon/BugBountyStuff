echo "[+] Testing HTTP Smuggling"

cat $1 | python3 ~/smuggler/smuggler.py --no-color -l smuggle.txt
