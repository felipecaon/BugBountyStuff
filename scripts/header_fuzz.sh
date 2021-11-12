# interlace -tL ~/domain_list -threads 30 -c "./header_fuzz.sh _target_"

counter=0
if [ "$counter" != 1 ]
then
        ((counter++))
        mkdir -p paths
fi

base=$(echo $1 | sed 's/http:\/\///g' | sed 's/https:\/\///g' | sed 's/\//g/')

ffuf -u $1 -w "~/wordlists/headers" -H "FUZZ: 127.0.0.1" -fw 0 -fs 0,1 -ac -mc 200,301,302 -w $2 -of json -o "headers/$base"

cat "headers/$base" | jq '.results[].url' >> "headers/${base}_found"

rm "headers/$base"
