echo ">> Running gau..."

echo $1 | gau --subs --blacklist png,jpg,gif,ttf,woff,svg,woff2,eot >> from_gau_$1.txt
echo "[+] gau done"
