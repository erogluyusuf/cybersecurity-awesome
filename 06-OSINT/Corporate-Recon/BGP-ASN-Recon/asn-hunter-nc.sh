#!/bin/bash

TARGET=$1

if [ -z "$TARGET" ]; then
    echo -e "\e[31mKullanım: ./asn-hunter-nc.sh <domain_veya_ip>\e[0m"
    exit 1
fi

echo -e "\e[34m[*] Hedef analiz ediliyor: $TARGET\e[0m"

# IPv4 Adresini bul
IP=$(getent ahostsv4 "$TARGET" | awk '{ print $1 }' | head -n 1)
if [ -z "$IP" ]; then
    IP=$TARGET
fi
echo -e "\e[32m[+] Hedef IPv4: $IP\e[0m"

echo -e "\n\e[34m[*] Netcat (nc) ile Team Cymru'dan ASN sorgulanıyor...\e[0m"
# whois yerine doğrudan TCP 43 portuna RAW bağlantı yapıyoruz!
ASN_INFO=$(echo "$IP" | nc whois.cymru.com 43 | tail -n 1)

ASN=$(echo "$ASN_INFO" | awk -F'|' '{print $1}' | tr -d ' ')
AS_NAME=$(echo "$ASN_INFO" | awk -F'|' '{print $7}' | sed 's/^[ \t]*//')

if [ -z "$ASN" ] || [ "$ASN" == "NA" ]; then
    echo -e "\e[31m[-] ASN bulunamadı veya bağlantı hatası.\e[0m"
    exit 1
fi

echo -e "\e[32m[+] Bulunan ASN: AS$ASN\e[0m"
echo -e "\e[32m[+] Kurum/ISP: $AS_NAME\e[0m"

echo -e "\n\e[34m[*] RADB veritabanından IP blokları çekiliyor...\e[0m"
# RADB'ye de nc ile bağlanıp !gAS parametresiyle prefixleri çekiyoruz
echo "!gAS$ASN" | nc whois.radb.net 43 | tr ' ' '\n' | grep -E "^[0-9]" > "AS${ASN}_prefixes.txt"

PREFIX_COUNT=$(wc -l < "AS${ASN}_prefixes.txt")
echo -e "\e[32m[+] Başarılı! $PREFIX_COUNT adet IP bloğu 'AS${ASN}_prefixes.txt' dosyasına kaydedildi.\e[0m"

echo -e "\n\e[33mÖrnek Bloklar (İlk 5):\e[0m"
head -n 5 "AS${ASN}_prefixes.txt"
