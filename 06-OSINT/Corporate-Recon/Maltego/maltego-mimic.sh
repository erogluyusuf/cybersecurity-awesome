#!/bin/bash

BLUE='\e[34m'
GREEN='\e[32m'
YELLOW='\e[33m'
RED='\e[31m'
NC='\e[0m'

function analyze() {
    TARGET=$1
    echo -e "${BLUE}[*] Maltego Transform Simülasyonu: $TARGET${NC}"
    echo -e "${BLUE}--------------------------------------------------${NC}"
    
    # 1. Domain to IP
    echo -e "${YELLOW}[Node: Domain] -> ${TARGET}${NC}"
    IP=$(dig +short $TARGET | tail -n1)
    if [ -z "$IP" ]; then
        echo -e "${RED}  [-] IP adresi çözümlenemedi.${NC}"
    else
        echo -e "${GREEN}  [Edge: DNS_A_RECORD] -> [Node: IPv4] -> $IP${NC}"
        
        # 2. IP to Infrastructure
        echo -e "${GREEN}  [Edge: INFRASTRUCTURE] -> [Details]:${NC}"
        whois $IP | grep -iE "Organization|NetName|Country" | head -n3 | sed 's/^/      /'
    fi

    # 3. MX Records
    echo -e "${YELLOW}[Node: MX Records]${NC}"
    MX=$(dig +short MX $TARGET)
    if [ -z "$MX" ]; then echo "      Bulunamadı"; else
        echo "$MX" | while read line; do echo -e "${GREEN}  [Edge: MAIL_SERVER] -> $line${NC}"; done
    fi
    
    # 4. Subdomains
    echo -e "${YELLOW}[Node: Subdomains]${NC}"
    for sub in www mail blog dev test; do
        if host "$sub.$TARGET" > /dev/null; then
            echo -e "${GREEN}  [Edge: SUB_NODE] -> $sub.$TARGET${NC}"
        fi
    done
    echo -e "${BLUE}--------------------------------------------------\n${NC}"
}

analyze "globipedi.com"
analyze "yestreyler.com"
