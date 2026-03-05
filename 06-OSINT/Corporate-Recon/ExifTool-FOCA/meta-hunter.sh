#!/bin/bash

TARGET=$1

if [ -z "$TARGET" ]; then
    echo -e "\e[31mKullanım: ./meta-hunter.sh <domain>\e[0m"
    exit 1
fi

echo -e "\e[34m==================================================\e[0m"
echo -e "\e[34m[*] Taşınabilir Metadata Avı Başlıyor: $TARGET\e[0m"
echo -e "\e[34m[*] Sitedeki PDF, DOCX, XLSX dosyaları aranıyor...\e[0m"
echo -e "\e[34m==================================================\e[0m\n"

# İndirilecek dosyalar için klasör aç
mkdir -p downloaded_docs
cd downloaded_docs

# Wget ile siteyi 2 derinlikte tarayıp sadece dokümanları indir (Sessiz mod)
wget -q -r -l 2 -A pdf,doc,docx,xls,xlsx,ppt,pptx "http://$TARGET" "https://$TARGET"

# Dosya indi mi diye kontrol et
FILES=$(find . -type f \( -iname "*.pdf" -o -iname "*.docx" -o -iname "*.xlsx" -o -iname "*.pptx" \))

if [ -z "$FILES" ]; then
    echo -e "\e[31m[-] Sitede analiz edilecek herhangi bir açık doküman bulunamadı!\e[0m"
    echo -e "\e[32m[+] OPSEC açısından bu mükemmel bir haber.\e[0m"
    cd ..
    rm -rf downloaded_docs
    exit 0
fi

echo -e "\e[32m[+] Dokümanlar yakalandı! Taşınabilir ExifTool ile içleri deşifre ediliyor...\e[0m"

for file in $FILES; do
    echo -e "\n\e[33m>>> Hedef Dosya: $file\e[0m"
    
    # İŞTE SİHİRLİ DOKUNUŞ: Sistemdeki değil, bizim klasördeki ExifTool'u kullanıyoruz!
    ../exiftool-local/exiftool "$file" | grep -i -E "Author|Creator|Software|Producer|Create Date|Company|Warning"
done

echo -e "\n\e[34m[*] Analiz Tamamlandı.\e[0m"
cd ..
# İstersen analiz bittikten sonra indirilenleri silmek için alttaki # işaretini kaldır
# rm -rf downloaded_docs
