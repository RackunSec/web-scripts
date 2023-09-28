#!/usr/bin/env bash
## Simple command line script to gather public key from TLS
## 2023 @RackunSec
usage () {
    printf "[!] Invalid $1 format.\n"
    printf "Usage: ./getPubCert.sh (DOMAIN) (PORT)\n"
    exit 1337
}
## Check arguments:
if [[ "$1" = "" || "$2" = "" ]];then 
    usage ## This will halt the app
fi
export port_regexp='^[0-9]+$'
export host_regexp='^[0-9A-Za-z-]+\.[a-zA-Z]+$'
if ! [[ $2 =~ $port_regexp ]];then ## Check if integer value
    usage "Port"
fi
if ! [[ $1 =~ $host_regexp ]];then
    usage "Domain"
fi
## Filenames:
export TEMPCERTCHAIN="tempcertchain.pem"
export PUBKEYFILE=${1}_pubkey.pem
## Output:
printf "[i] Public Cert Gathering Tool\n"
printf "[i] Using domain: $1\n"
printf "[i] Using port: $2\n"
## Get the certificate chain:
test=$(openssl s_client -connect ${1}:${2} 2>&1 < /dev/null | sed -n '/-----BEGIN/,/-----END/p' > $TEMPCERTCHAIN)
openssl x509 -pubkey -in $TEMPCERTCHAIN -noout > $PUBKEYFILE ## extract the public TLS certificate
rm -rf $TEMPCERTCHAIN ## Remove file
ls -la $PUBKEYFILE
printf "[i] Public key contents ($PUBKEYFILE):\n"
cat $PUBKEYFILE
