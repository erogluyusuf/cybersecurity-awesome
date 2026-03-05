import sys
from googlesearch import search
import time

if len(sys.argv) < 2:
    print("Kullanım: python auto-dork.py <domain>")
    sys.exit()

target = sys.argv[1]

# En ölümcül 4 Google Dork kategorisi
dorks = {
    "Kritik Dosya ve Veritabanı Sızıntıları": f"site:{target} ext:pdf OR ext:docx OR ext:txt OR ext:sql OR ext:env",
    "Açık Dizinler (Directory Listing)": f"site:{target} intitle:\"index of\"",
    "Yönetici Panelleri ve Giriş Kapıları": f"site:{target} inurl:admin OR inurl:login",
    "Subdomain Keşfi (www Hariç)": f"site:*.{target} -www"
}

print(f"\n\033[92m[*] {target} için Tam Otomatik Dork Kazıyıcı Başlıyor...\033[0m")
print("\033[93m[*] Not: Google bot korumasına takılmamak için sorgular arası bilerek bekleniyor...\033[0m\n")

for title, query in dorks.items():
    print(f"\033[94m[+] Kategori: {title}\033[0m")
    print(f"    Sorgu: {query}")
    try:
        # num_results: Kaç sonuç getirileceği, sleep_interval: Ban yememek için bekleme süresi
        results = list(search(query, num_results=5, sleep_interval=3))
        
        if not results:
            print("    \033[92m[-] Sonuç bulunamadı (Temiz).\033[0m")
        else:
            for r in results:
                print(f"    \033[91m[!] ZAFİYET / BULGU:\033[0m {r}")
    except Exception as e:
        print(f"    \033[91m[X] Google Engeli veya Hata:\033[0m {e}")
    print("-" * 60)
