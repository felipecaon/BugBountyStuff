#!/bin/bash
#
# Bash script i use to install some hacking tools
#

printf "update and upgrade:\n"
sudo apt update -y
sudo apt upgrade -y


printf "[+] Done"

printf "\n#####################\n\n"

printf "[*] Setup Your Environment:\n"
printf "[+] Install Golang:\n"

wget https://go.dev/dl/go1.19.linux-amd64.tar.gz -O golang.tar.gz 1>/dev/null

local="/usr/local"
printf "$local"
rm -rf /usr/local/go && tar -C /usr/local -xzf golang.tar.gz

mkdir $HOME/bin
mkdir $HOME/tools
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bashrc

source $HOME/.bashrc

rm golang.tar.gz

printf "[+] Done"

printf "\n#########################\n\n"

printf "[*] Setup Your Tools:\n"

printf "Make & GCC:\n"
sudo apt install -y make gcc

printf "JQ:\n"
sudo apt -y install jq

printf "Libpcap\n:"
sudo apt install -y libpcap-dev

printf "SubFinder:\n"
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

printf "Nuclei:\n"
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest

printf "Httpx:\n"
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

printf "Naabu:\n"
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest

printf "Ffuf:\n"
go install github.com/ffuf/ffuf@latest

printf "Gau:\n"
go install github.com/lc/gau/v2/cmd/gau@latest

printf "Anew\n"
go install -v github.com/tomnomnom/anew@latest

printf "Unfurl:\n"
go install github.com/tomnomnom/unfurl@latest

printf "Hakrawler:\n"
go install github.com/hakluke/hakrawler@latest

printf "MassDNS:\n"
git clone https://github.com/blechschmidt/massdns $HOME/tools/massdns
cd $HOME/tools/massdns && make && cp ./bin/massdns $HOME/bin
rm -rf $HOME/tools
mv $HOME/bin/massdns /usr/local/bin
rm -rf $HOME/bin

printf "PureDNS:\n"
go install github.com/d3mondev/puredns/v2@latest

printf "nmap:\n"
sudo apt install -y nmap

# printf "Resolvers:\n"
# git clone git@github.com:felipecaon/resolvers.git

