# Prepends words to domain name, eg: google.com -> admin.google.com, test.google.com, jenkins.google.com
# joiner.sh [domain] [wordlist]

if [ -z "$1" ]
  then
    echo "No domain supplied"
	exit 0
fi
if [ -z "$2" ]
  then
    echo "No wordlist supplied"
	exit 0
fi

domain=$1
awk -v d="$domain" '{print $0 "." d}' $2 > joined_$1_${2##*/}.txt