# interlace -tL ~/domain_list -threads 30 -c "./path_fuzz.sh _target_ wordlist_file"

counter=0
if [ "$counter" != 1 ]
then
        ((counter++))
        mkdir -p paths
fi

base=$(echo $1 | sed 's/http:\/\///g' | sed 's/https:\/\///g' | sed 's/\///g')

ffuf -u $1/FUZZ -fw 0 -fs 0,1 -ac -mc 200 -w $2 -of json -o "paths/$base"

cat "paths/$base" | jq '.results[].url' >> "paths/${base}_found"

rm "paths/$base"
