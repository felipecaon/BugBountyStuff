# Usage: ffuf_quick <list_of_domains>

xargs -P5 -I@ sh -c 'ffuf -u @/FUZZ -w quick.txt -mc all -ac -o all.txt -maxtime 600 -v' < $1
