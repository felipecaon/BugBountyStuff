import sys

scope = sys.argv[1];
wordlist = open('/opt/listas/subs/subs.txt').read().split('\n')

for word in wordlist:
    if not word.strip(): 
        continue
    print('{}.{}'.format(word.strip(), scope))
