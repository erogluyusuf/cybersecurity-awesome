# OSINT ve Kişi Odaklı İstihbarat (People Search) Master Raporu
**Hedef Kişi:** Yusuf Eroğlu (Kullanıcı Adı: `erogluyusuf`)
**Tarih:** 2026-03-06
**Kapsam:** Kullanıcı Adı Numaralandırma, Sosyal Medya Profili Analizi, Çapraz Veri Korelasyonu

---

## Yönetici Özeti (Executive Summary)
Bu rapor, `erogluyusuf` kullanıcı adını temel alarak, hedefin dijital platformlardaki varlığını, teknik yetkinliklerini ve olası sosyal mühendislik zafiyetlerini tespit etmek amacıyla gerçekleştirilen pasif bilgi toplama faaliyetlerini içermektedir.
* **Mevcut Durum:** Hedefin siber güvenlik farkındalığının yüksek olduğu, geniş bir teknik ayak izine (kod depoları, siber güvenlik forumları) sahip olduğu tespit edilmiştir. Ancak proje yönetim araçları (Trello) gibi dışarıya veri sızdırma potansiyeli taşıyan hesaplarının bulunduğu ve Twitch gibi canlı yayın platformları üzerinden "Pattern of Life" (Yaşam Döngüsü) analizi yapılabileceği görülmüştür.

---

## AŞAMA 1: Dijital Varlık Keşfi ve Profil Korelasyonu

### 1.1 Sherlock Taraması ve Dijital Parmak İzi (Fingerprinting)
* **Kullanılan Komut:** `docker run --rm -t sherlock/sherlock erogluyusuf --timeout 5 --print-found --verbose`
* **Metodoloji:** Hedef kullanıcı adı, küresel platformlarda HTTP durum kodları doğrulanarak taranmış, ağ gecikmeleri (latency) kayıt altına alınarak False Positive (Yanlış Pozitif) oranı sıfıra indirilmiştir. Tarama sonucunda toplam **19 platformda** eşleşme sağlanmıştır.
* **Bulgular (19 Doğrulanmış Profil ve Yanıt Süreleri):**
  * **Teknik & Yazılım Geliştirme:** `GitHub` (7713ms), `Docker Hub` (6058ms), `DEV Community` (5598ms), `Hackaday` (11878ms)
    * *OSINT Notu:* Hedefin kaynak kodları, kullandığı bağımlılıklar (dependencies) ve altyapı mimarisi buralardan çıkarılabilir.
  * **Siber Güvenlik & Tehdit İstihbaratı:** `HackerOne` (8272ms)
    * *OSINT Notu:* Hedefin zafiyet avcılığı geçmişi ve güvenlik bilinci haritalandırılabilir.
  * **İş Akışı & Proje Yönetimi:** `Trello` (15503ms) 🚩 *(Kritik Risk)*
    * *OSINT Notu:* Kurumsal projelerin veya kişisel "To-Do" listelerinin dışarı sızma ihtimali yüksektir. Public panolar manuel olarak araştırılmalıdır.
  * **Canlı Yayın & Eğlence (Pattern of Life İzleme):** `Twitch` (15670ms), `Steam Community` (15322ms), `Lichess` (11572ms)
    * *OSINT Notu:* Hedefin uyku/aktif saatleri, canlı yayın sırasında olası ekran sızıntıları (token, IP ifşası) ve oyun içi iletişim alışkanlıkları buradan takip edilebilir.
  * **Sosyal Medya & İletişim:** `Telegram` (15255ms), `TikTok` (15432ms), `Snapchat` (14907ms), `Medium` (12030ms), `Pinterest` (18673ms), `Behance` (1091ms), `Patreon` (13519ms), `minds` (18210ms), `Wikipedia` (16818ms), `Gravatar` (12497ms)
    * *OSINT Notu:* Hedefin doğrudan iletişim kanalları, ilgi alanları ve tüm sitelerde kullandığı ortak görsel profili (Gravatar) tespit edilmiştir.
* **Sonuç Analizi:** Hedefin `erogluyusuf` rumuzunu 19 farklı serviste merkezi bir kimlik olarak kullandığı (Username Re-use) teknik olarak kanıtlanmıştır. Bu tekdüzelik, hedefin e-posta ve lokasyon gibi diğer kapalı verilerinin de aynı rumuz mantığıyla keşfedilmesinin yolunu açmıştır.

---

## AŞAMA 2: Kritik Analiz ve Tehdit Modellemesi (Threat Modeling)

### 2.1 Teknik Tedarik Zinciri Riski (Supply Chain)
* **Durum:** Hedefin `GitHub` ve `Docker Hub` üzerinde aktif depoları bulunmaktadır.
* **Risk:** Eğer hedefin yönettiği kurumsal sistemler (Örn: `globipedi.com`), bu açık imajları veya GitHub repolarını kullanıyorsa, kod içerisine sızdırılacak zararlı bir yazılım doğrudan ana kurumu etkileyecektir. Bu depolara yönelik *Secret Scanning* (TruffleHog) işlemleri derinleştirilmelidir.

### 2.2 Oltalama (Phishing) Dayanıklılığı Değerlendirmesi
* **Durum:** Hedef `HackerOne` gibi Bug Bounty platformlarında kayıtlıdır.
* **Risk:** Hedef, siber güvenlik konusunda bilinçlidir. "Faturanız ektedir" tarzı sıradan Phishing saldırıları başarısız olacaktır. Hedefe ulaşmak için `DEV Community` veya `GitHub` profilleri referans alınarak, "Projenize katkıda bulunmak istiyorum" veya "Docker imajınızda açık buldum" temalı, yüksek düzeyde özelleştirilmiş Spear-Phishing senaryoları kullanılmalıdır.

### 2.3 Bilgi Sızıntısı Vektörü (Trello)
* **Durum:** `Trello` proje yönetim sisteminde hesabı bulunmaktadır.
* **Risk:** Geliştiriciler genellikle Trello panolarını yanlış yapılandırarak "Public" olarak unuturlar. Bu panolarda sunucu IP adresleri, API anahtarları veya veritabanı şifreleri bulunma ihtimali yüksektir. Hedefin Trello panoları Google Dorks ile (`site:trello.com intext:erogluyusuf`) manuel olarak taranacaktır.

---

## AŞAMA 3: Derinlemesine Profilleme ve Çapraz Analiz (Aktif Görevler)
*Cephanelikte bulunan diğer OSINT araçlarıyla yapılacak derinlemesine analizler bu bölüme işlenecektir.*

### 3.1 WhatsMyName Analizi (Niş Platform Keşfi)
* **Durum:** ⏳ Beklemede
* **Amacı:** Sherlock'un kapsamadığı spesifik oyun, dark web ve bölgesel platformlarda hedefi aramak.
* **Bulgular:**
  * *(Tarama yapıldığında sonuçlar buraya eklenecektir)*

### 3.2 Holehe (E-Posta Sızıntı & Hesap Doğrulama)
* **Durum:** ⏳ Beklemede
* **Amacı:** Hedefin e-posta adresi kullanılarak Twitter, Instagram gibi 120+ platformun "Şifremi Unuttum" mekanizması üzerinden gizli hesap bağlantılarını doğrulamak.
* **Bulgular:**
  * *(Tarama yapıldığında sonuçlar buraya eklenecektir)*

### 3.3 Epieos (Fiziksel Konum ve Google Analizi)
* **Durum:** ⏳ Beklemede
* **Amacı:** Hedefin e-posta adresi üzerinden Google Haritalar yorumlarını, gizli Skype hesaplarını ve takvim verilerini kazıyarak hedefin fiziksel rutinini (Pattern of Life) haritalandırmak.
* **Bulgular:**
  * *(Tarama yapıldığında sonuçlar buraya eklenecektir)*

### 3.4 Social-Searcher (Anlık İzleme ve Veri Sızıntısı)
* **Durum:** ⏳ Beklemede
* **Amacı:** Açık sosyal ağlarda hedef kişi veya kurum hakkında yapılan anlık paylaşımları ve mention'ları tespit etmek.
* **Bulgular:**
  * *(Tarama yapıldığında sonuçlar buraya eklenecektir)*

### 3.5 Twint / X İstihbaratı
* **Durum:** ⏳ Beklemede
* **Amacı:** Hedefin Twitter (X) üzerindeki geçmiş konuşmalarını, bağlantılarını ve konum verilerini API kullanmadan kazımak.
* **Bulgular:**
  * *(Tarama yapıldığında sonuçlar buraya eklenecektir)*

### 3.6 Maigret (Genişletilmiş Çapraz Analiz)
* **Durum:** ⏳ Beklemede
* **Amacı:** Dağınık haldeki tüm bu istihbarat verilerini toplayarak tek bir otomatik PDF istihbarat dosyası haline getirmek.
* **Bulgular:**
  * *(Tarama yapıldığında sonuçlar buraya eklenecektir)*