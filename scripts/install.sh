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
tar -xvf $local -xzf golang.tar.gz 1>/dev/null

mkdir $HOME/bin
mkdir $HOME/tools
export GOROOT=$local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:$HOME/bin

echo "export GOROOT=$local/go" >> $HOME/.bashrc
echo "export GOPATH=$HOME/go" >> $HOME/.bashrc
echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:$HOME/bin' >> $HOME/.bashrc
echo 'source $HOME/.zsh_profile' >> $HOME/.bashrc

source $HOME/.bashrc

printf "[+] Done"

printf "\n#########################\n\n"

printf "[*] Setup Your Tools:\n"

printf "Htop:\n"
sudo apt install htop

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
go install github.com/ffuf/ffuf@lates

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

printf "PureDNS:\n"
go install github.com/d3mondev/puredns/v2@latest

printf "nmap:\n"
sudo apt install -y nmap

printf "Resolvers:\n"
git clone git@github.com:felipecaon/resolvers.git

