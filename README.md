# Scalable iOS Architecture: MVVM-C + Factory + Repository

![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

Bu proje, modern iOS uygulamalarında sıkça karşılaşılan **"Massive View Controller"**, **"Fat Coordinator"** ve **"Tight Coupling"** sorunlarına çözüm olarak geliştirilmiştir.

Sıradan bir MVVM-C yapısının ötesine geçerek; **Factory Pattern** ile Dependency Injection yönetimini merkezi hale getirir ve **Repository Pattern** ile veri katmanını soyutlayarak sürdürülebilir bir mimari sunar.

---

## 🎯 Projenin Amacı

Bir iOS projesinin mimari evrimini **3 aşamada simüle ederek**, neden **Factory** ve **Repository** yapılarının ölçeklenebilirlik için bir lüks değil, **zorunluluk** olduğunu kanıtlamaktır.

Proje, mimari sorunları ve çözümleri şu evrim basamaklarıyla ele alır:

1.  ❌ **Case 1 (MVVM-C + Adapter):** Tight Coupling ve Test Edilemezlik sorunları.
2.  ❌ **Case 2 (MVVM-C + Adapter + Repository):** Fat Coordinator ve Dependency Hell sorunları.
3.  ✅ **Case 3 (MVVM-C + Factory + Adapter + Repository):** Merkezi DI yönetimi, Loose Coupling ve Tam Test Edilebilirlik (Nihai Çözüm).

---

## 🛠 Kullanılan Teknolojiler & Prensipler

Proje, endüstri standartlarına uygun modern iOS geliştirme pratikleriyle hazırlanmıştır.

| Alan | Teknoloji / Prensip |
| :--- | :--- |
| **Architecture** | MVVM-C (Model-View-ViewModel-Coordinator) |
| **UI** | UIKit (Programmatic - No Storyboard) |
| **Design Patterns** | Factory, Repository, Adapter |
| **Network** | Alamofire & Decodable (Generic Network Layer) |
| **Concurrency** | Async/Await |
| **Principles** | SOLID, DRY, Separation of Concerns |

---


<br>
<br>

# ❓ Neden Repository + Adapter Pattern yaninda Factory kullanmak zorunda kaldim
<img width="1024" height="1236" alt="ChatGPT Image Jan 3, 2026, 01_09_33 AM" src="https://github.com/user-attachments/assets/0dae8193-8d8c-4c29-a218-773d0294cf5c" />

<br>


## Folder Structure
```swift
MVVM-C-Factory-Repository-CleanArch
├── Application                            <-- Uygulamanın yaşam döngüsü ve kurulum merkezi
│   ├── Coordinators                       <-- Navigasyon (Sayfa geçiş) yöneticileri
│   │   ├── Protocols
│   │   │   └── Coordinator.swift          <-- Tüm koordinatörlerin uyması gereken temel kurallar
│   │   ├── AppCoordinator.swift           <-- Uygulamanın ilk açılış akışını yöneten kök yönetici
│   │   └── HomeCoordinator.swift          <-- Home ve Detail arasındaki geçişleri yöneten sınıf
│   ├── Factories
│   │   └── AppFactory.swift               <-- DI Container: Tüm sınıfların (VC, VM, Repo) üretildiği fabrika
│   ├── AppDelegate.swift                  <-- Uygulama açılış/kapanış olaylarını dinleyen sistem dosyası
│   └── SceneDelegate.swift                <-- Pencere (UIWindow) yönetimini ve AppCoordinator'ı başlatan yer
│
├── Core                                   <-- Projenin altyapısı (Hiçbir feature'a bağlı olmayan araçlar)
│   ├── Enums
│   │   └── ViewState.swift                <-- UI durumları (Loading, Success, Failure)
│   └── Networking                         <-- Ağ katmanı çekirdeği
│       ├── Endpoint.swift                 <-- URL parçalarını (path, method) standartlaştıran protokol
│       ├── NetworkError.swift             <-- Uygulama genelinde kullanılacak hata tipleri
│       ├── NetworkManager.swift           <-- Alamofire/URLSession işlemini yapan motor (Engine)
│       ├── NetworkServiceProtocol.swift   <-- Mock test yazabilmek için motorun soyut hali (Interface)
│       └── NetworkLogger.swift            <-- İstek ve cevapları konsola şık bir şekilde basan araç
│
├── Domain                                 <-- Projenin Beyni (En iç katman, Framework bağımsız)
│   ├── Entities
│   │   └── PostResponse.swift             <-- Saf veri modeli (Data katmanından buraya taşıdık ✅)
│   └── Interfaces
│       └── PostRepositoryProtocol.swift   <-- Data katmanının uyması gereken sözleşme (Ne yapılacağını söyler, nasıl yapılacağını bilmez)
│
├── Data                                   <-- Uygulama Detayları (Dış dünya ile iletişim)
│   ├── Networking
│   │   └── HomeAPI.swift                  <-- Endpoint protokolünü uygulayan rota tanımları (Router)
│   └── Repositories
│       └── PostRepository.swift           <-- Veriyi gerçekten getiren işçi sınıf (API'den mi DB'den mi geleceğine karar verir)
│
└── Presentation                           <-- Kullanıcı Arayüzü (UI) Katmanı
    └── Scenes
        ├── Detail                         <-- Detay Modülü
        │   ├── DetailViewController.swift <-- Sadece ekrana çizim yapan sınıf (View)
        │   └── DetailViewModel.swift      <-- Detay verisini işleyen ve View'a sunan mantık katmanı
        └── Home                           <-- Ana Sayfa Modülü
            ├── HomeContracts.swift        <-- ViewModel ile Coordinator arasındaki iletişim protokolleri
            ├── HomeViewController.swift   <-- Listeyi gösteren UI sınıfı
            └── HomeViewModel.swift        <-- Listeyi çeken ve kullanıcı etkileşimlerini (Tıklama vb.) yöneten sınıf
```


Genel sorularım şöyleydi:

- MVVM-C ile Adapter Pattern tek başına yetmez miydi?
- MVVM-C ile  Adapter + Repository Pattern ler bu ikiside mi yetmedi?
- MVVM-C ile Factory + Adapter + Repository Pattern ler nihai hali bu olan kodumuz her şeyi çözüyor muydu?

**Factory'nin neden bir lüks değil, zorunluluk olduğunun kanıtı**.

<br>
<br>

# Case 1 : Sadece "MVVM-C + Adapter" Yetmez miydi?

*(Burada Repository yok, Factory yok. Network işlemleri ViewModel içinde yapılıyor varsayalım.)*

**Bu durumda şöyle yapımız var:**

- Coordinator'ın içinde `HomeViewModel` oluşturuyoruz.
- ViewModel içinde de Alamofire (Network) var.

```swift
// HomeCoordinator.swift (KÖTÜ SENARYO)
func start() {
    let viewModel = HomeViewModel() // NetworkManager içinde gizli veya burada yaratılıyor
    let vc = HomeViewController(viewModel: viewModel)
    navigationController.pushViewController(vc, animated: true)
}
```

**Neden Yetmedi? (Problemler):**

1. **Tight Coupling (Sıkı Bağlılık):** ViewModel, doğrudan Alamofire'a bağımlı olur. Yarın "Alamofire'ı silip URLSession kullanacağız" dersek **tüm ViewModel'leri** tek tek değiştirmemiz gerekir.
2. **Test Edilemezlik:** ViewModel'i test etmek istersek, gerçekten internete çıkıp API isteği atar. Mock data kullanamayız çünkü araya girecek bir katman (Repository) yok.
3. **Tekrar Eden Kod:** Her ViewModel (Home, Detail, Profile) API isteği atma kodunu (Alamofire request) kendi içinde yazar.

---

<br>
<br>

# Case 2 : "MVVM-C + Adapter + Repository" Yetmez miydi?

*(Factory yok. Coordinator, Repository'yi yaratıp ViewModel'e veriyor.)*

- Bu adımda veri katmanını (Repository) soyutladık. 
Artık ViewModel, Alamofire'ı bilmiyor. Bu güzel ama bizim Coordinator ne hale geldi?

```swift
// HomeCoordinator.swift (FACTORY OLMAYAN SENARYO)
func start() {
    //  Coordinator her şeyi bilmek zorunda kalıyor!!!!!!
    let networkManager = NetworkManager()
    let repository = PostRepository(networkService: networkManager)
    let viewModel = HomeViewModel(repository: repository)
    
    let vc = HomeViewController(viewModel: viewModel)
    navigationController.pushViewController(vc, animated: true)
}
```

**Neden Yetmedi? (Problemler):**

1. **Fat Coordinator:** 
    - Coordinator'ın görevi sadece "A sayfasından B sayfasına gitmek"tir.
    - Ama yukarıdaki kodda Coordinator; **NetworkManager'ı, Repository'yi, ViewModel'i ve ViewController'ı** yaratmayı biliyor.
2. **Dependency Hell:** 
    - Yarın `PostRepository` içine `DatabaseManager` diye yeni bir parametre eklesek,
    gidip **HomeCoordinator'ı, DetailCoordinator'ı ve ProfileCoordinator'ı** güncellememiz gerekir. Çünkü nesne üretimi her yere dağılmıştır.
3. **Kural İhlali (SRP):** 
    - Single Responsibility Principle (Tek Sorumluluk Prensibi) ihlal ediliyor.
    - Coordinator hem "Navigasyon" yapıyor hem de "Dependency Injection".

---

<br>
<br>



# Case 3 : "MVVM-C + Factory + Adapter + Repository" (Nihai Hal)

*(Coordinator sadece Factory'den ister, gerisine karışmaz.)*

Factory Pattern burada **"Dependency Injection Container"** (Bağımlılık Kutusu = DI Container) görevi görür.

```swift
// HomeCoordinator.swift (FACTORY OLAN SENARYO - Güzel senaryo :))
func start() {
    // Coordinator: "Bana Home ekranını ver, içini nasıl doldurduğun umrumda değil."
    let vc = factory.makeHomeViewController(coordinator: self)
    navigationController.pushViewController(vc, animated: true)
}
```

**Neden İhtiyacımız Oldu ve Ne Çözüldü?**

1. **Merkezi Üretim (Centralized Creation):**
    - `PostRepository`'nin init metodu değişirse (örneğin yeni bir parametre eklenirse), 
    sadece `AppFactory.swift` dosyasını güncelleriz. Böylece Coordinator'ların ruhu bile duymamış olur. Kodumuzun bakımı inanılmaz kolaylaşır.
2. **Coordinator'ın Özgürleşmesi:**
    - Coordinator artık `PostRepository`'yi, `NetworkManager`'ı veya `ViewModel`'i tanımaz. 
    Sadece `UIViewController` tanır. Bu, **Loose Coupling (Gevşek Bağlılık)**'in zirvesidir.
3. **Test Edilebilirlik (Mocking):**
Coordinator testlerini yazarken, gerçek Factory yerine `MockFactory` verebiliriz.
    - `MockFactory`, boş bir `UIViewController` döner.
    - Böylece navigasyon testini yaparken network veya database ile uğraşmayız.
4. **Dependency Injection (DI) Yönetimi:**
Uygulama büyüdükçe; Analytics Servisi, User Session, Database, Remote Config gibi onlarca servis olacak.
    - **Factory Olmasaydı:** Bu servisleri her Coordinator'da tek tek oluşturup taşımak zorunda kalacaktık.
    - **Factory Varken:** Factory bunları `init` içinde bir kere oluşturur ve ihtiyaç duyan ekrana (Home, Detail) otomatik enjekte eder.

---

| **Mimari Parçası** | **Çözdüğü Sorun (Sorumluluğu)** | **Olmazsa Ne Olur?** |
| --- | --- | --- |
| **Coordinator (C)** | Sayfa geçişlerini (Navigasyon) yönetir. | Bir VC, diğer VC'yi tanır (pushViewController yazar). |
| **Repository** | Verinin nereden geleceğini (API/DB) yönetir. | ViewModel içinde API kodları olur. Test yazılamaz. |
| **Adapter** (Response->Model) | API verisini UI'ın anlayacağı dile çevirir. | API değişirse tüm UI kodları patlar. |
| **Factory**  | **Nesnelerin yaratılmasını ve bağlanmasını yönetir.** | **Coordinator, tüm proje detaylarına (API, Repo, DB) bağımlı hale gelir.** |

### Sonuç: MVVM-C + Factory + Repository üçlüsü

- **Repository:** Veriyi soyutladı.
- **Factory:** Bağımlılıkları (Dependency) soyutladı.
- **Coordinator:** Navigasyonu soyutladı.
- **MVVM:** UI durumunu soyutladı.

<br>
<br>
