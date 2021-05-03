RELATIVE_JS_FILES=jsfiles_relative_.txt
JS_FILES=jsfiles_links.txt
WITHOUT_HTTP=jsfiles_withouthttp.txt

find $1 -name "*.body" | html-tool attribs src | anew $RELATIVE_JS_FILES

for x in $(cat $RELATIVE_JS_FILES)
do
    if [[ $x == *".js"* ]]; then
        if [[ $x == *"https"* ]]; then
            echo "lins:"
            echo $x | anew $JS_FILES
        else
            echo "nolink"
            grep -or $x $1 | sort -u | awk -v char=$x -F  "/" '{print $2"/"char}' | anew $WITHOUT_HTTP
        fi
    fi
done

sed -i 's/\/\//\//gi' $WITHOUT_HTTP
sed -i 's/\/\//\//gi' $WITHOUT_HTTP

cat $WITHOUT_HTTP | httpx -silent | anew $JS_FILES
#wget -i $JS_FILES -P jsfiles
cat $JS_FILES | fff -S -o jsfiles

rm $RELATIVE_JS_FILES
rm $JS_FILES
rm $WITHOUT_HTTP
