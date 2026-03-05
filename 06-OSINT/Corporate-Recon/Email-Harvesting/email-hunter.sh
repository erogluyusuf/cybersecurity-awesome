#!/bin/bash

TARGET=$1

if [ -z "$TARGET" ]; then
    echo -e "\e[31mKullanım: ./email-hunter.sh <domain>\e[0m"
    exit 1
fi

echo -e "\e[34m==================================================\e[0m"
echo -e "\e[34m[*] E-Posta Avı Başlıyor: $TARGET\e[0m"
echo -e "\e[34m==================================================\e[0m\n"

echo -e "\e[33m[1] Skymem Veritabanı Taranıyor...\e[0m"
curl -s "http://www.skymem.info/srch?q=$TARGET" | grep -oE "[a-zA-Z0-9._%+-]+@$TARGET" | sort -u > skymem_emails.txt
if [ -s skymem_emails.txt ]; then
    cat skymem_emails.txt | while read email; do echo -e "    \e[32m[+] Bulundu: $email\e[0m"; done
else
    echo -e "    \e[31m[-] Skymem üzerinde sonuç bulunamadı.\e[0m"
fi

echo -e "\n\e[33m[2] Hedefin Kendi Web Sayfaları (Ana Sayfa ve İletişim) Kazınıyor...\e[0m"
curl -sL "https://$TARGET" | grep -oE "[a-zA-Z0-9._%+-]+@$TARGET" | sort -u > web_emails.txt
curl -sL "https://$TARGET/iletisim" | grep -oE "[a-zA-Z0-9._%+-]+@$TARGET" | sort -u >> web_emails.txt
curl -sL "https://$TARGET/contact" | grep -oE "[a-zA-Z0-9._%+-]+@$TARGET" | sort -u >> web_emails.txt

# Çift olanları temizle
sort -u web_emails.txt > final_web_emails.txt

if [ -s final_web_emails.txt ]; then
    cat final_web_emails.txt | while read email; do echo -e "    \e[32m[+] Web Sitesinden Çekildi: $email\e[0m"; done
else
    echo -e "    \e[31m[-] Web sayfalarında açıkta e-posta bulunamadı.\e[0m"
fi

echo -e "\n\e[34m[*] İşlem Tamamlandı.\e[0m"
rm -f skymem_emails.txt web_emails.txt final_web_emails.txt
