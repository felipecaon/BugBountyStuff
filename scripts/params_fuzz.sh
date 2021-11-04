# interlace -tL ~/domain_list -threads 30 -c "./params_fuzz.sh _target_ wordlist_file"

counter=0
if [ "$counter" != 1 ]
then
	((counter++))
	mkdir -p params
fi

base=$(echo $1 | sed 's/http:\/\///g' | sed 's/https:\/\///g')

x8 -u $1 -w $2 -O url -o "params/$base"
