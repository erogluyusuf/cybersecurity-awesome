# People Search (Kişi Odaklı İstihbarat)

Bu bölüm, hedef organizasyonun çalışanları, yöneticileri veya doğrudan spesifik bir hedef kişi (Target Person) hakkında dijital ayak izi toplamak için kullanılan araçları ve kaynakları içermektedir. Amacımız; sosyal medya sızıntıları, forum kayıtları, kullanıcı adı (username) korelasyonları ve açık kaynakları kullanarak hedefin dijital profilini (profiling) uçtan uca haritalandırmaktır.

## Uygulamalı Saha Raporu (Laboratuvar)
Araçların gerçek bir hedef üzerinde (kullanıcı adı çapraz analizi) nasıl çalıştığını görmek için aşağıdaki saha raporunu inceleyebilirsiniz:
* **[Yusuf Eroğlu - Profil Analizi ve Sherlock Uygulaması](../Corporate-Recon/globipedi-corporate-recon.md)** *(Not: Kurumsal raporun son bölümüne entegre edilmiştir.)*

## Araçlar ve Yazılımlar

### Kullanıcı Adı (Username) ve Profil Korelasyonu
* [Sherlock](https://github.com/sherlock-project/sherlock) - Yüzlerce sosyal medya, kod deposu ve forum sitesinde (GitHub, Twitter, Reddit, TikTok vb.) hedef kullanıcı adını hızlıca tarayarak kişinin dijital varlıklarını tespit eden en temel OSINT aracı.
* [Maigret](https://github.com/soxoj/maigret) - Sherlock'un daha gelişmiş bir türevi olup, sadece kullanıcı adı bulmakla kalmaz; aynı zamanda profiller arası veri kazıma (scraping) ve PDF/HTML formatında kapsamlı hedef raporları çıkarma yeteneklerine sahiptir.
* [WhatsMyName](https://github.com/WebBreacher/WhatsMyName) - Kullanıcı adlarının internetteki hangi web sitelerinde (oyun, iş, sosyal) aktif olduğunu anında listeleyen, geniş çaplı ve açık kaynaklı bir numaralandırma aracı.

### E-Posta ve Kimlik Deşifresi
* [Epieos](https://github.com/epieos/epieos-tools) - Hedefin sadece e-posta adresini veya telefon numarasını kullanarak Google, Skype, LinkedIn gibi platformların arkasındaki gizli hesaplarını, profil fotoğraflarını ve Google Haritalar yorumlarını deşifre eden araç.
* [Holehe](https://github.com/megadose/holehe) - Bir e-posta adresinin Twitter, Instagram, Imgur ve 120'den fazla sitede bir hesaba bağlı olup olmadığını, şifre sıfırlama işlevlerini (parola unutma zafiyeti) kullanarak tespit eden modül.

### Sosyal Ağ ve Ağ Analizi
* [Social-Searcher](https://www.social-searcher.com/) - Hedef kişi veya anahtar kelime hakkında sosyal ağlarda anlık olarak kimlerin ne konuştuğunu, mentions ve sızıntıları izleyen web tabanlı arama motoru.
* [Twint](https://github.com/twintproject/twint) (Deprecated/Alternatifler: Nitter) - Twitter'ın (X) API'sini kullanmadan hedef kullanıcının geçmiş tweetlerini, bağlantılarını ve konum verilerini kazıyan gelişmiş istihbarat aracı.

## Kaynaklar ve Okuma Listesi
* [IntelTechniques (Michael Bazzell)](https://inteltechniques.com/) - Kişi tabanlı OSINT, mahremiyet (privacy) ve dijital iz silme konularında dünya standartlarında metodolojiler ve arama araçları barındıran efsanevi kaynak.
* [OSINT Framework (Username/Email Sections)](https://osintframework.com/) - Hedef profil analizi yaparken kullanabileceğiniz tüm veri tabanlarının ve araçların interaktif haritası.
* [Bellingcat's Digital Investigation Methodologies](https://www.bellingcat.com/category/resources/) - Gerçek dünya araştırmacıları tarafından kişilerin dijital izlerinin, konumlarının ve kimliklerinin nasıl doğrulandığına dair vaka analizleri.

---
*Bu listeye katkıda bulunmak isterseniz lütfen ana dizindeki `CONTRIBUTING.md` dosyasını okuyun.*