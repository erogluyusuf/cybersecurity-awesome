#!/bin/bash

EMAIL=$1

if [ -z "$EMAIL" ]; then
    echo -e "\e[31mKullanım: ./breach-checker.sh <hedef_eposta>\e[0m"
    exit 1
fi

echo -e "\e[34m==================================================\e[0m"
echo -e "\e[34m[*] Sızıntı Avı Başlıyor: $EMAIL\e[0m"
echo -e "\e[34m[*] Veritabanı: XposedOrNot (Free HIBP Alternative)\e[0m"
echo -e "\e[34m==================================================\e[0m\n"

# API'ye istek atıyoruz
RESPONSE=$(curl -s "https://api.xposedornot.com/v1/check-email/$EMAIL")

# Eğer dönen cevapta "Error" kelimesi varsa (temizse)
if echo "$RESPONSE" | grep -q "Error"; then
    echo -e "\e[32m[+] HARİKA HABER: Bu e-posta adresi herhangi bir veri sızıntısında (breach) bulunamadı!\e[0m"
else
    echo -e "\e[31m[!] KRİTİK UYARI: Bu e-posta adresi geçmiş veri sızıntılarında (Dark Web) yer alıyor!\e[0m"
    echo -e "\e[33m[*] Sızıntı Kaynakları (Breaches):\e[0m"
    
    # JSON çıktısını bash ile temizleyip sadece sızıntı kaynaklarını ekrana basıyoruz
    echo "$RESPONSE" | grep -o '"breaches":\[[^]]*\]' | sed 's/"breaches":\[//' | sed 's/\]//' | tr ',' '\n' | sed 's/"//g' | while read breach; do
        echo -e "    \e[31m-> $breach\e[0m"
    done
    
    echo -e "\n\e[93m[!] YORUM: Eğer bu platformlarda kullanılan şifre kurumun ana sistemlerinde de kullanılıyorsa, sistem tehlikededir!\e[0m"
fi
