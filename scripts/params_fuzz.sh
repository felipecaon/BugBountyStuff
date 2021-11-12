# interlace -tL ~/domain_list -threads 30 -c "./params_fuzz.sh _target_"

counter=0
if [ "$counter" != 1 ]
then
	((counter++))
	mkdir -p params
fi

base=$(echo $1 | sed 's/http:\/\///g' | sed 's/https:\/\///g' | sed 's/\///g')

x8 -u $1 -w "~/wordlists/params" -O url -o "params/$base"

