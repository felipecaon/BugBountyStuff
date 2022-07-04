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

codes=$(cat "paths/${base}_found" | grep -Eoh "Status[:0-9a-zA-Z].+$" | sort | uniq -c)
final_grep=""

#echo $codes

length_of_response=$(echo $codes | wc -w)

#echo $length_of_response

amount_of_checks=$(($length_of_response/4))

#echo $amount_of_checks

for i in $( seq 1 $amount_of_checks )
do
  echo "counter: $i"
  size=$((($i*4)-3))
  #echo $size
  offset_word=$(echo $codes | awk -v var="$size" '{print $var}')

  if [ $offset_word -ge 500 ]; then
    begin=$(($size+1))
    end=$(($size*4))
    to_ignore=$(echo $codes | cut -d" " -f${begin}-${end})
    if [ $i -eq $amount_of_checks ]; then
      final_grep+=$to_ignore
    else
      final_grep+="${to_ignore}\|"
    fi
  fi

  echo "grep -v ${final_grep}"

  cat "paths/${base}_found" | grep -v "${final_grep}" >> "paths/${base}_triaged"

done

rm "paths/${base}_found"
