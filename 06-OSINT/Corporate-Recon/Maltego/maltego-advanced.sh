#!/bin/bash

# Tam yol tanımlaması (Sanal ortam hatalarını aşmak için)
WHOIS_BIN=$(which whois)

DOMAIN_COLOR='\e[1;34m' 
IP_COLOR='\e[1;32m'     
ORG_COLOR='\e[1;35m'    
MAIL_COLOR='\e[1;33m'   
INFO_COLOR='\e[0;36m'   
RED='\e[31m'
YELLOW='\e[33m'
NC='\e[0m'

echo -e "${INFO_COLOR}[!] Maltego Advanced Engine Başlatılıyor...${NC}\n"

function run_transform() {
    TARGET=$1
    echo -e "${DOMAIN_COLOR}[Node: Domain] 🌐 $TARGET${NC}"
    
    IP=$(dig +short $TARGET | tail -n1)
    if [ ! -z "$IP" ]; then
        echo -e "  ├── ${IP_COLOR}[Edge: DNS_A] ➔ [Node: IPv4] 📍 $IP${NC}"
        
        # Whois komutu kontrolü ve çalıştırma
        if [ ! -z "$WHOIS_BIN" ]; then
            ORG=$($WHOIS_BIN $IP | grep -iE "Organization|NetName|descr" | head -n1 | cut -d':' -f2 | xargs)
            COUNTRY=$($WHOIS_BIN $IP | grep -i "Country" | head -n1 | cut -d':' -f2 | xargs)
            echo -e "  │    └── ${ORG_COLOR}[Edge: OWNED_BY] ➔ [Node: Infrastructure] 🏢 $ORG ($COUNTRY)${NC}"
        fi
    fi

    MX_RECORDS=$(dig +short MX $TARGET)
    if [ ! -z "$MX_RECORDS" ]; then
        echo -e "  ├── ${MAIL_COLOR}[Edge: HAS_MX] ➔ [Node: Mail Server] 📧${NC}"
        echo "$MX_RECORDS" | while read mx; do
            echo -e "  │    └── ${INFO_COLOR}↳ $mx${NC}"
        done
    fi

    NS_RECORDS=$(dig +short NS $TARGET)
    echo -e "  ├── ${INFO_COLOR}[Edge: MANAGED_BY] ➔ [Node: DNS Server] ⚙️${NC}"
    echo "$NS_RECORDS" | while read ns; do
        echo -e "  │    └── ${INFO_COLOR}↳ $ns${NC}"
    done
    
    echo -e "\n--------------------------------------------------\n"
}

run_transform "globipedi.com"
run_transform "yestreyler.com"

# KORELASYON ANALİZİ
echo -e "${RED}[!] KORELASYON ANALİZİ (Bağlantı Tespiti)${NC}"
IP1=$(dig +short globipedi.com | tail -n1)
IP2=$(dig +short yestreyler.com | tail -n1)

if [ ! -z "$WHOIS_BIN" ]; then
    ORG1=$($WHOIS_BIN $IP1 | grep -iE "Organization|NetName" | head -n1)
    ORG2=$($WHOIS_BIN $IP2 | grep -iE "Organization|NetName" | head -n1)
    echo -e "${INFO_COLOR}[*] Altyapı Karşılaştırılıyor...${NC}"
    # Basit bir eşleşme kontrolü
    if [[ "$ORG1" == "$ORG2" ]]; then
        echo -e "${YELLOW}[!] YATAY BAĞLANTI: Farklı IP'ler ama AYNI VERİ MERKEZİ / ŞİRKET bünyesinde.${NC}"
    else
        echo -e "${INFO_COLOR}[+] Altyapılar farklı şirketlere (Cloudflare vs. Turhost) ait görünüyor.${NC}"
    fi
fi
