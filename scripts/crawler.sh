key="${1}"

echo $key

if [ $key == "--subs" ]; then
	echo "Starting gau with subs"
	DOMAIN=$2
	gau $2 --subs --o gauout.txt
else
	echo "Starting gau"
	DOMAIN=$1
	gau $1 --o gauout.txt
fi

cat gauout.txt | grep -v "\.png\|\.jpg\|\.jpeg\|\.tiff\|\.woff2\|\.woff" | httpx -mc 200 >> valid_gau.txt
cat valid_gau.txt valid_domains >> to_spider.txt
gospider -S to_spider.txt -d 5 -t 10 -c 10 | grep -o -E "(([a-zA-Z][a-zA-Z0-9+-.]*\:\/\/)|mailto|data\:)([a-zA-Z0-9\.\&\/\?\:@\+-\_=#%;,])*" >> gospider.txt

echo "[+] Iniciando junção de arquivos"
echo "${DOMAIN}"
cat gauout.txt gospider.txt | grep "${DOMAIN}" | anew crawled.txt

cat valid_domains | while read line
do
   curl -k "${line}"/sitemap.xml | grep "<loc>" | awk -F"<loc>" '{print $2}' | awk -F"</loc>" '{print $1}' | anew crawled.txt
done

cat crawled.txt | grep "\.js\|\.json" >> js_files.txt
cat crawled.txt | grep "=" >> with_parameter.txt
cat crawled.txt | grep -v "\.png\|\.jpg\|\.jpeg\|\.tiff\|\.woff2\|\.woff" | httpx -mc 200,403,302,301 | anew crawled_valid.txt

rm gospider.txt gauout.txt valid_gau.txt to_spider.txt crawled.txt

cat js_files.txt | grep -v "jquery\|wp-includes\|wp-content\|bootstrap" >> js_to_download.txt
cat js_to_download.txt | xargs -I@ sh -c "waybackpack @ -d wayback_javascripts/"

rm js_to_download.txt js_files.txt

cat crawled_valid.txt | fff -S -o crawled_download/
cat crawled_valid.txt | grep "\.js" >> valid_js.txt
cat crawled_valid.txt | grep  "\.pdf\|\.swf\|\.txt\|\.conf\|\.xml\|\.php\|\.sql\|\.doc\|\.ppt\|\.json\|\.action\|\.bak\|\.backup\|\.bkf\|\.bkp\|\.bok\|\.config\|\.crt\|\.cst\|\.csv\|\.dat\|\.eml\|\.env\|\.exe\|\.ini\|\.inf\|\.java\|\.key\|\.log\|\.lst\|\.passwd\|\.pem\|\.pgb\|\.pwd\|\.rdp\|\.yml" >> interestingEXT.txt
