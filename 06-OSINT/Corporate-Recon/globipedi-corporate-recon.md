#  OSINT ve Kurumsal Keşif (Corporate Recon) Master Raporu
**Hedef Kurum:** globipedi.com
**Tarih:** 2026-03-04
**Kapsam:** Pasif Bilgi Toplama, Açık Kaynak İstihbaratı (OSINT), Sızıntı Analizi

---

##  Yönetici Özeti (Executive Summary)
Bu rapor, `globipedi.com` alan adına yönelik gerçekleştirilen pasif bilgi toplama faaliyetlerinin sonuçlarını içermektedir. Hedef sisteme doğrudan temas edilmemiş, yalnızca açık kaynaklar kullanılmıştır.
* **Mevcut Durum:** Kurumun e-posta sızıntılarına karşı iyi korunduğu, ancak `admin` ve `ftp` gibi kritik alt alan adlarının dışarıdan keşfedilebilir durumda olduğu tespit edilmiştir. Hedefin Cloudflare arkasında olduğu (104.21.13.150, 172.67.200.160) doğrulanmıştır.

---

##  AŞAMA 1: Saldırı Yüzeyi ve Alt Alan Adı (Subdomain) Keşfi

### 1.1 theHarvester Bulguları 
* **Pasif Komut:** `theHarvester -d globipedi.com -b all -l 500`
* **Aktif (DNS Brute-Force) Komut:** `theHarvester -d globipedi.com -b all -c -l 500`
* **Bulgular:**
  * **E-posta / Çalışan Sızıntısı:** Bulunamadı.
  * **Hedef IP Adresleri (Cloudflare Arkasında):** `104.21.13.150`, `172.67.200.160`
  * **Tespit Edilen Kritik Alt Alan Adları:**
    * `admin.globipedi.com` 🚩 *(Kritik: Potansiyel Yönetim Paneli)*
    * `cv.globipedi.com`
    * `example.globipedi.com`
    * `ftp.globipedi.com` 🚩 *(Kritik: Dosya Transfer Protokolü)*
    * `mail.globipedi.com`
    * `mim.globipedi.com`
    * `movie.globipedi.com`
    * `pdf.globipedi.com` *(Aktif DNS Taramasıyla bulundu)*
    * `project.globipedi.com`
    * `yenimezun.globipedi.com`
  * **⚠️ DNS Wildcard Tespiti:** Aktif (Brute-Force) tarama sırasında yüzlerce sahte (False Positive) subdomain tespit edildi. Sistemin `*.globipedi.com` (Wildcard) kaydı kullandığı ve rastgele istekleri ana IP'ye yönlendirdiği doğrulandı. Yalnızca karşılığında IP dönen sonuçlar listeye eklendi.

### 1.2 Sublist3r Bulguları 
* **Kullanılan Komut:** `python3 sublist3r.py -d globipedi.com`
* **Bulgular (8 Domain):**
  * `cv.globipedi.com`, `example.globipedi.com`, `mim.globipedi.com`, `movie.globipedi.com`, `project.globipedi.com`, `yenimezun.globipedi.com` *(theHarvester ile eşleşti)*
  * **Yeni Eklenenler:** `www.globipedi.com`, `www.example.globipedi.com`
* **Notlar ve Araç Kısıtlamaları:** Tarama sırasında aracın güncel olmamasından kaynaklı olarak DNSdumpster modülü HTML parse hatası (CSRF Token) vermiş ve VirusTotal API'si istekleri bloklamıştır. Bu durum, pasif bilgi toplamada tek bir araca güvenmemenin önemini bir kez daha kanıtlamıştır.

### 1.3 OWASP Amass Bulguları 
* **Kullanılan Komut:** `docker run -it --rm caffix/amass enum -passive -d globipedi.com`
* **Bulgular (Altyapı İstihbaratı):**
  * **Mail Sunucusu (MX):** `mx.turkticaret.net` *(Hedefin e-posta altyapısının Turkticaret üzerinde barındırıldığı tespit edildi).*
  * **NameServer (NS):** `sasha.ns.cloudflare.com`, `beau.ns.cloudflare.com` *(Cloudflare koruması kesinleşti).*
* **Notlar:** API anahtarları (Shodan, VirusTotal vb.) yapılandırılmadığı ve ücretsiz OSINT kaynakları rate-limit (429) uyguladığı için yeni bir subdomain keşfedilememiştir.

### 1.4 crt.sh Sertifika Analizi 
* **Kullanılan Yöntem:** `curl` ve `jq` kullanılarak Certificate Transparency (Sertifika Şeffaflığı) JSON veritabanı sorgulanmış, ham veri (Tarih, Issuer, Seri No) çekilmiştir.
* **Kritik Bulgular ve Altyapı İstihbaratı:**
  1. **Tedarikçi / Üçüncü Taraf Bağlantısı (Pivot Noktası):** * Hedefin altyapısının `yestreyler.com` ile doğrudan bir entegrasyonu (veya geçmiş barındırma bağı) olduğu kesinleşmiştir (`*.globipedi.com.yestreyler.com`, `www.mim.globipedi.com.yestreyler.com` vb.). Bu alan adı, Tedarik Zinciri (Supply Chain) saldırı yüzeyi olarak hedeflere eklenmelidir.
  2. **Aktif Geliştirme Zaman Çizelgesi:** * Sertifikaların oluşturulma tarihleri (Mart 2025 - Şubat 2026 aralığı), hedefin aktif olarak yönetildiğini ve kod dağıtımı yapıldığını göstermektedir. Sistem terk edilmiş (zombi) değildir.
  3. **Kullanılan Sertifika Otoriteleri (CA) Analizi:** * **Let's Encrypt & ZeroSSL:** Bu ücretsiz otoritelerin yaygın kullanımı, alt alan adlarında (`cv`, `mim`, `project`) otomatik CI/CD ve yenileme süreçlerinin kullanıldığına işaret eder.
     * **Google Trust Services (WE1):** Ana domainlerde Cloudflare/Google Web korumasının aktif olduğunu doğrular.
  4. **Cloudflare Atlatma (Bypass) Hazırlığı:** * Shodan veya Censys üzerinde yapılacak aktif taramalarda kullanılmak üzere, hedefin arkasındaki gerçek (korumasız) IP'yi bulmaya yarayacak eşsiz **Sertifika Seri Numaraları** (Örn: `00877a3...`, `547c0fe...`, `0662015...`) başarıyla toplanmış ve kayıt altına alınmıştır. Bu numaralar Ağ Analizi (Aşama 2) aşamasında kullanılacaktır.

### 1.5 Recon-ng Modül Testleri 
* **Kullanılan Modül:** `recon/domains-hosts/hackertarget`
* **Bulgular:**
  * `cv.globipedi.com` -> `104.21.13.150`
  * `movie.globipedi.com` -> `172.67.200.160`
* **Analiz:** HackerTarget API'si üzerinden yapılan sorgulama, önceki aşamalarda tespit edilen Cloudflare IP bloklarını doğrulamıştır. Recon-ng üzerinde "globipedi" çalışma alanı (workspace) oluşturulmuş ve tüm OSINT veritabanı merkezi olarak kayıt altına alınmaya başlanmıştır.cl

---

##  AŞAMA 2: Ağ ve Altyapı Analizi

### 2.1 Shodan Pasif Port Analizi (Kısıtlı ⚠️)
* **Durum:** Shodan API üzerinden yapılan sorgulamalarda 403 Forbidden (Access Denied) hatası alınmıştır.
* **Analiz:** Hedefin Cloudflare arkasında olması ve Shodan'ın ücretsiz API limitleri nedeniyle doğrudan IP/Domain sorgusu yapılamamıştır. Bu durum, kurumun Cloudflare kalkanının Shodan gibi pasif tarayıcılara karşı da bir nebze koruma sağladığını göstermektedir.
* **Aksiyon:** Bir sonraki aşamada Censys veya Shodan web arayüzü üzerinden manuel sertifika-IP eşleştirmesi denenecektir.

### 2.2 BGP/ASN Haritalaması 
* **Kullanılan Araç / Metod:** `asn-hunter-nc.sh` (Netcat üzerinden TCP 43 RAW WHOIS sorguları)
* **Bulgular:**
  * `globipedi.com` -> `104.21.13.150` | **ASN:** AS13335 (Cloudflare) | **IP Bloğu:** 3473 adet
  * `mx.turkticaret.net` -> `31.186.18.100` | **ASN:** AS197720 (Turkticaret) | **IP Bloğu:** 32 adet
* **Analiz:** Hedefin ana web trafiği AS13335 (Cloudflare) arkasında gizlenerek geniş bir koruma kalkanı sağlanmıştır. Ancak, MX kayıtları üzerinden yapılan analizle hedefin arka planda AS197720 numaralı altyapıyı kullandığı deşifre edilmiştir. Elde edilen 32 adet daraltılmış IP bloğu (`31.186.x.x` vb.), aktif tarama aşamaları için hedefin "gerçek" saldırı yüzeyini oluşturmaktadır.

---

##  AŞAMA 3: Bulut, Kod Deposu ve Dosya Sızıntıları

### 3.1 Google Dorks / GHDB Genişletilmiş Taraması 
* **Kullanılan Araç / Metod:** Özel Python ve Bash Otomasyon Betiği (`auto-dork.py` + `for loop`)
* **Kapsam:** Ana domain ve tespit edilen 10 kritik alt alan adı (Örn: `admin`, `ftp`, `cv`, `mail`, `mim`, `yenimezun` vb.)
* **Tarama Kategorileri:**
  * Kritik Dosya ve Veritabanı Sızıntıları (`ext:pdf, ext:sql, ext:env` vb.)
  * Açık Dizinler (`intitle:"index of"`)
  * Yönetici ve Giriş Panelleri (`inurl:admin, inurl:login`)
* **Bulgular:** Temiz (Herhangi bir sızıntı bulunamadı).
* **Analiz:** Kurumun ana domaini ve tüm hassas alt alan adları üzerinde yapılan genişletilmiş Google indeks taramalarında hiçbir açık dizin, yönetim paneli veya kritik belge sızıntısına (metadata) rastlanmamıştır. Hedefin arama motoru görünürlüğü (OPSEC) kurallarının katı ve başarılı bir şekilde uygulandığı doğrulanmıştır.

### 3.2 Git Recon / Sızıntı Taraması 
* **Kullanılan Araç:** TruffleHog v3.93.7
* **Kapsam:** GitHub `Globipedi` organizasyonuna ait tüm açık depolar (5 Adet: `Globipedi-Server`, `Globipedi`, `PanTracker-Google-extension`, `HeartFit-Mobile-Android`, `HeartFit-Website`)
* **Bulgular:** 0 Onaylanmış Sır (Verified Secret), 0 Doğrulanmamış Sır. (Temiz)
* **Analiz:** Hedef organizasyonun herkese açık kaynak kod depolarında, geçmiş commitler (versiyon geçmişi) de dahil olmak üzere hiçbir geçerli API anahtarı, veritabanı şifresi veya hassas token sızıntısına rastlanmamıştır. Geliştirici ekibinin güvenli kodlama prensiplerine uygun hareket ettiği değerlendirilmektedir.

### 3.3 Cloud Storage Analizi 
* **Kullanılan Araç:** `cloud_enum`
* **Aranan Anahtar Kelimeler:** `globipedi`, `heartfit`, `pantracker`
* **Bulgular:**
  * `http://heartfit.s3.amazonaws.com/` -> **[!] PROTECTED** (Korumalı)
* **Analiz:** Yapılan geniş çaplı AWS, Azure ve GCP taramalarında `heartfit` anahtar kelimesiyle eşleşen, ancak dışarıya kapalı (Protected) bir S3 Bucket tespit edilmiştir. Hedef mimaride bulut kullanılmadığı bilindiğinden, bu deponun global isim benzerliğinden (False Positive) kaynaklandığı değerlendirilmiştir. Kuruma ait herhangi bir açık (Public) veri sızıntısı bulunmamaktadır.

---

##  AŞAMA 4: Kimlik İhlalleri ve Metadata Analizi

### 4.1 E-Posta Keşfi ve Sızıntı Analizi 
* **Kullanılan Araçlar:** Özel Bash Scriptleri (`email-hunter.sh` ve `breach-checker.sh`), Skymem, XposedOrNot API
* **Hedefler:** `globipedi.com`, `yestreyler.com`
* **Bulgular:** Temiz (0 E-Posta Bulundu, 0 Sızıntı Tespit Edildi).
* **Analiz:** Hedef kuruma ve ilişkili alan adlarına ait yüzey ağında (Surface Web) açık e-posta adresi tespit edilememiştir. E-posta bulunamadığı için HaveIBeenPwned/DeHashed mantığıyla yapılan Dark Web şifre sızıntısı testleri negatif sonuçlanmıştır. Kurumun oltalama (phishing) saldırılarına karşı saldırı yüzeyi son derece dardır.

### 4.2 Doküman Metadata Analizi 
* **Kullanılan Araç:** Taşınabilir `ExifTool` Framework (Özel Bash Otomasyonu)
* **Metodoloji:** Hedef alan adı (`globipedi.com`) üzerinden örümcek (spidering) yöntemiyle doküman taraması ve manuel PoC (Proof of Concept) analizi.
* **Bulgular:**
  * **Saha Taraması:** Otomatik taramalarda yüzey ağında (Surface Web) unutulmuş veya indekslenmiş kritik ofis dokümanına rastlanmamıştır (Yüksek OPSEC Skoru).
  * **Canlı Dosya Analizi (`cv_yusuf_eroglu_visyoneks.pdf`):** Yapılan derinlemesine analizde `Author: yusuf eroğlu` ve `Creator: Canva` verileri doğrulanmıştır.
  * **Simülasyon Bulgusu:** Laboratuvar ortamında test edilen `sirket_etkinligi.jpg` dosyasından **tam GPS koordinatları** ve cihaz bilgileri başarıyla ayıklanmıştır.
* **Analiz:** Hedef sistemde otomatik tarayıcıların erişebileceği bir metadata sızıntısı bulunmamaktadır. Manuel olarak erişilen belgelerin ise bulut tabanlı araçlarla (Canva) üretildiği, bu sayede lokal sistem yolları ve kullanıcı bilgilerinin sızmasının engellendiği tespit edilmiştir.

---

##  AŞAMA 5: İlişki Analizi ve Görselleştirme

### 5.1 Maltego Ağ Haritası ve Korelasyon Analizi 
**Kullanılan Metodoloji:**  
Maltego-Advanced-Mimic (Custom Bash Transform Engine)
**Tespit Edilen Varlık Bağlantıları:**
- **globipedi.com**
  - Cloudflare (WAF)
  - IP: 104.21.13.150
  - Mail Altyapısı: Turkticaret MX
- **yestreyler.com**
  - Hosting: Turhost
  - IP: 94.199.205.100
  - Mail Altyapısı: Google Workspace MX

**Kritik Korelasyon:**
Her iki domain üzerinde gerçekleştirilen DNS ve mail altyapısı analizlerinde, sistemlerin farklı servis sağlayıcılar kullanmasına rağmen yönetimsel olarak aynı organizasyon tarafından kontrol edildiğini gösteren bir **yatay bağlantı (Lateral Connection)** tespit edilmiştir.
**Analiz:**
Farklı hosting ve mail altyapıları kullanılması doğrudan teknik bir bağlantıyı gizlese de, altyapı bileşenleri ve yönetimsel yapı analiz edildiğinde sistemlerin tek bir merkez tarafından yönetildiği anlaşılmaktadır.
Bu durum, güvenlik perspektifinden bakıldığında şu riski doğurmaktadır:
- Daha az güvenlik katmanına sahip olabilecek bir yan domain (**yestreyler.com**) üzerinden,
- Ana sistem veya markaya (**globipedi.com**) yönelik dolaylı erişim veya bilgi toplama ihtimali ortaya çıkabilir.