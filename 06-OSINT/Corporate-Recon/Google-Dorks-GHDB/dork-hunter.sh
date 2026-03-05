#!/bin/bash

TARGET=$1

if [ -z "$TARGET" ]; then
    echo -e "\e[31mKullanım: ./dork-hunter.sh <domain>\e[0m"
    exit 1
fi

echo -e "\e[34m==================================================\e[0m"
echo -e "\e[34m[*] $TARGET için Google Dorks (GHDB) Otomasyonu\e[0m"
echo -e "\e[34m==================================================\e[0m\n"

echo -e "\e[32m[1] Kritik Dosya ve Metadata Sızıntıları (PDF, DOCX, TXT, SQL, ENV vb.):\e[0m"
echo "https://www.google.com/search?q=site:$TARGET+ext:pdf+OR+ext:docx+OR+ext:txt+OR+ext:sql+OR+ext:env"
echo ""

echo -e "\e[32m[2] Açık Dizinler (Directory Listing Zafiyeti):\e[0m"
echo "https://www.google.com/search?q=site:$TARGET+intitle:%22index+of%22"
echo ""

echo -e "\e[32m[3] Yönetici (Admin) ve Giriş Panelleri:\e[0m"
echo "https://www.google.com/search?q=site:$TARGET+inurl:admin+OR+inurl:login+OR+inurl:portal+OR+intitle:test"
echo ""

echo -e "\e[32m[4] Subdomain Keşfi (www Hariç):\e[0m"
echo "https://www.google.com/search?q=site:*.$TARGET+-www"
echo ""

echo -e "\e[32m[5] Kritik Hata Mesajları ve Log Sızıntıları:\e[0m"
echo "https://www.google.com/search?q=site:$TARGET+%22fatal+error%22+OR+%22stack+trace%22+OR+%22error+log%22"
echo ""

echo -e "\e[33m[*] İPUCU: Terminalin destekliyorsa linklerin üzerine CTRL+Tıklama yaparak tarayıcıda doğrudan açabilirsin.\e[0m"
