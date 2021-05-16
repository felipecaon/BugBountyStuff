# $1 list of valid http(s):// domains
# $2 getjsfromsource.sh file

cat $1 | fff -S -o roots
$2 roots
cat $1 | gauplus -t 40 | anew gau