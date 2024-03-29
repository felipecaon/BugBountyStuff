#!/bin/bash

printf "update and upgrade:\n"
sudo apt update -y
sudo apt upgrade -y
sudo apt --fix-broken install

printf "[+] Done"

printf "\n#####################\n\n"

printf "[*] Setup Your Environment:\n"
printf "[+] Install Golang:\n"

wget https://go.dev/dl/go1.19.linux-amd64.tar.gz -O golang.tar.gz 1>/dev/null

local="/usr/local"
printf "$local"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf golang.tar.gz

mkdir $HOME/bin
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bashrc

source $HOME/.bashrc

rm golang.tar.gz

printf "[+] Done"

printf "\n#########################\n\n"

printf "[*] Setup Linux Essential Tools:\n"

printf "Curl:\n"
sudo apt install -y curl

printf "Htop:\n"
sudo apt install -y htop

printf "Make & GCC:\n"
sudo apt install -y make gcc

printf "Ruby:\n"
sudo apt install -y ruby-full

printf "Python3:\n"
sudo apt install -y python3

printf "Pip3:\n"
sudo apt install -y python3-pip

printf "Chrome headless:\n"
sudo apt install -y libappindicator1 fonts-liberation
sudo apt install -y libnss3-dev libgdk-pixbuf2.0-dev libgtk-3-dev libxss-dev
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb
rm google-chrome*.deb

printf "JQ:\n"
sudo apt install -y jq

printf "Libpcap\n:"
sudo apt install -y libpcap-dev

printf "Libpcap\n:"
sudo apt install -y libssl-dev

printf "\n#########################\n\n"
printf "[*] Setup Your Tools:\n"

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
git clone https://github.com/blechschmidt/massdns
cd $HOME/massdns && make && sudo cp ./bin/massdns /usr/local/bin
rm -rf $HOME/massdns

printf "PureDNS:\n"
go install github.com/d3mondev/puredns/v2@latest

printf "nmap:\n"
sudo apt install -y nmap

printf "dnsx:\n"
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest

printf "gowtiness:\n"
go install github.com/sensepost/gowitness@latest

#wpscan
#sqlmap
#x8

