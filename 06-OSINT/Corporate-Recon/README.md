# Corporate Recon

Bu bölüm, **Corporate Recon** (Kurumsal Bilgi Toplama ve Pasif OSINT) alanı ile ilgili uçtan uca araçlar, kaynaklar, makaleler ve notlar içermektedir. Amacımız, hedef kurumun altyapısına dokunmadan, açık kaynakları kullanarak en geniş dijital ayak izini (saldırı yüzeyini) haritalandırmaktır.

##  Uygulamalı Saha Raporu (Laboratuvar)
Buradaki araçların pratikte nasıl kullanıldığını, birbirleriyle nasıl entegre edildiğini ve gerçek bir kurumun dijital ayak izinin adım adım nasıl çıkarıldığını görmek için örnek OSINT raporumuzu inceleyebilirsiniz:
*  **[globipedi.com OSINT Master Raporu](globipedi-corporate-recon.md)**

##  Araçlar ve Yazılımlar

### Temel Keşif ve Subdomain (Alt Alan Adı) Analizi
* [theHarvester](https://github.com/laramies/theHarvester) - Arama motorları ve açık kaynaklar üzerinden e-posta hesapları, alt alan adları ve çalışan profillerini toplayan pasif keşif aracı.
* [OWASP Amass](https://github.com/owasp-amass/amass) - Açık kaynak bilgi toplama tekniklerini kullanarak detaylı ağ haritalaması ve derinlemesine alt alan adı tespiti yapan kapsamlı araç.
* [Sublist3r](https://github.com/aboul3la/Sublist3r) - Baidu, Yahoo, Google, Bing vb. motorları kullanarak hızlı bir şekilde alt alan adlarını listeleyen popüler araç.
* [Recon-ng](https://github.com/lanmaster53/recon-ng) - Metasploit benzeri modüler yapısıyla web tabanlı açık kaynak istihbaratı (OSINT) toplamak için tasarlanmış framework.

### Bulut (Cloud) ve Kod Deposu (Git) Keşfi
* [TruffleHog](https://github.com/trufflesecurity/trufflehog) / [Gitleaks](https://github.com/gitleaks/gitleaks) - GitHub, GitLab gibi platformlarda hedefe ait sızmış API anahtarlarını, şifreleri ve gizli verileri (secrets) tarayan araçlar.
* [cloud_enum](https://github.com/initstring/cloud_enum) - Hedef şirkete ait açık bırakılmış veya yanlış yapılandırılmış AWS S3 bucket'larını, Azure Blob ve GCP depolama alanlarını tespit eden araç.

### Ağ Haritalama ve IoT Analizi
* [Shodan](https://www.shodan.io/) - İnternete bağlı cihazları, açık portları ve zafiyetli servisleri pasif olarak analiz etmek için kullanılan arama motoru.
* [BGP Toolkit (bgp.he.net)](https://bgp.he.net/) - Şirketlerin sahip olduğu IP bloklarını (IPv4/IPv6) ve ASN (Otonom Sistem Numarası) kayıtlarını bularak devasa ağ haritaları çıkarmak için kullanılan veritabanı.

### Veri Sızıntısı, Kimlik ve Belge Analizi
* [ExifTool](https://exiftool.org/) / [FOCA](https://github.com/ElevenPaths/FOCA) - İnternette bulunan şirket belgelerinin (PDF, DOCX) içindeki gizli meta verileri (yazılımcı isimleri, iç ağ IP adresleri, yazılım sürümleri) çıkaran araçlar.
* [DeHashed](https://dehashed.com/) / [HaveIBeenPwned](https://haveibeenpwned.com/) - Kurumsal e-posta adreslerinin geçmiş veri ihlallerinde ve sızdırılmış veritabanlarında yer alıp almadığını kontrol eden platformlar.
* [crt.sh (Certificate Transparency)](https://crt.sh/) - SSL/TLS sertifika şeffaflığı loglarını tarayarak gizli veya dev/test ortamlarına ait alt alan adlarını bulmaya yarayan platform.
* [Maltego](https://www.maltego.com/) - Toplanan veriler (IP, alan adı, e-posta) arasındaki karmaşık ilişkileri görselleştirmek ve bağlantı analizi yapmak için grafiksel yazılım.

##  Kaynaklar ve Okuma Listesi
* [Google Hacking Database (GHDB)](https://www.exploit-db.com/google-hacking-database) - Google arama motorunu (Dorks) kullanarak hassas dosyaları, yapılandırma hatalarını ve şifreleri bulmak için arama operatörleri arşivi.
* [OSINT Framework](https://osintframework.com/) - Pasif bilgi toplama süreçlerinde hangi veriyi nereden bulabileceğinizi gösteren devasa, etkileşimli ağaç haritası.
* [OWASP Information Gathering](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/01-Information_Gathering/README) - Web uygulama güvenliği testleri için bilgi toplama metodolojisi ve rehberi.
* [Bellingcat's Online Investigation Toolkit](https://docs.google.com/document/d/1BfLPJpRtyq4RFtHJoNpvWQjmGnyVkfE2HYoICKOGguA/edit) - Dijital araştırmalar ve açık kaynak istihbaratı konusunda dünyanın önde gelen grubunun araç listesi.
* [GitHub Dorks](https://github.com/techgaun/github-dorks) - GitHub üzerinde şirketlere ait sızmış hassas verileri bulmak için kullanılabilecek özel arama terimleri koleksiyonu.

---
*Bu listeye katkıda bulunmak isterseniz lütfen ana dizindeki `CONTRIBUTING.md` dosyasını okuyun.*