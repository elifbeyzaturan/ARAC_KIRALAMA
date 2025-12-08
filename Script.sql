-- ============================================
-- ARAÇ KİRALAMA VERİTABANI - TAM VERİ
-- 100 Kullanıcı, 100 Araç, 270 Rezervasyon
-- ============================================

DROP DATABASE IF EXISTS arac_kiralama;
CREATE DATABASE arac_kiralama CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE arac_kiralama;

-- ===================
-- 1. KULLANICILAR 
-- ===================
CREATE TABLE Kullanicilar (
  KullaniciID INT AUTO_INCREMENT PRIMARY KEY,
  Ad VARCHAR(50),
  Soyad VARCHAR(50),
  Eposta VARCHAR(100) UNIQUE,
  SifreHash VARCHAR(255),
  Telefon VARCHAR(15) UNIQUE,
  EhliyetNumarasi VARCHAR(20) UNIQUE,
  KayitTarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Kullanicilar (Ad, Soyad, Eposta, SifreHash, Telefon, EhliyetNumarasi, KayitTarihi) VALUES
('Ahmet','Yılmaz','ahmet.yilmaz01@gmail.com','123456','0551 234 56 70','EHLAD048','2020-01-12 14:27:33'),
('Elif','Kara','elif.kara02@hotmail.com','123456','0551 903 21 84','EHLAH428','2020-02-05 10:42:11'),
('Berke','Demir','berke.demir03@gmail.com','123456','0552 678 14 39','EHLAI631','2020-03-18 19:03:58'),
('Zeynep','Aydın','zeynep.aydin04@hotmail.com','123456','0553 742 90 12','EHLAM454','2020-04-09 16:54:21'),
('Mert','Can','mert.can05@gmail.com','123456','0554 398 27 61','EHLAR505','2020-05-14 11:39:45'),
('Ece','Yıldız','ece.yildiz06@hotmail.com','123456','0555 810 43 29','EHLAS015','2020-06-27 09:16:50'),
('Emre','Kurt','emre.kurt07@gmail.com','123456','0552 506 45 37','EHLAT536','2020-07-11 23:08:14'),
('Ayşe','Yalçın','ayse.yalcin08@hotmail.com','123456','0550 527 38 15','EHLBR923','2020-08-03 20:57:09'),
('Onur','Koçak','onur.kocak09@gmail.com','123456','0553 899 18 03','EHLBU652','2020-09-22 12:45:32'),
('Derya','Polat','derya.polat10@hotmail.com','123456','0551 557 99 48','EHLBV013','2020-10-05 18:14:55'),
('Ali','Şahin','ali.sahin11@gmail.com','123456','0554 574 56 63','EHLBW658','2021-01-14 13:22:09'),
('Melisa','Koç','melisa.koc12@hotmail.com','123456','0555 787 61 00','EHLCF992','2021-02-03 09:50:43'),
('Baran','Yüce','baran.yuce13@gmail.com','123456','0552 788 46 70','EHLCG387','2021-02-19 15:34:22'),
('İrem','Arslan','irem.arslan14@hotmail.com','123456','0550 656 56 11','EHLCN439','2021-03-11 17:12:57'),
('Furkan','Şen','furkan.sen15@gmail.com','123456','0551 449 98 79','EHLDK330','2021-03-28 22:31:18'),
('Ceren','Kaya','ceren.kaya16@hotmail.com','123456','0553 290 60 55','EHLDM090','2021-04-09 09:45:02'),
('Hakan','Aksoy','hakan.aksoy17@gmail.com','123456','0554 700 11 24','EHLEC312','2021-04-27 21:08:44'),
('Nazlı','Demir','nazli.demir18@hotmail.com','123456','0550 315 74 92','EHLEL196','2021-05-12 19:23:13'),
('Yusuf','Yalın','yusuf.yalin19@gmail.com','123456','0552 982 03 61','EHLFA871','2021-05-29 14:14:07'),
('Can','Özkan','can.ozkan20@hotmail.com','123456','0553 411 39 27','EHLFK209','2021-06-07 11:49:36'),
('Selin','Er','selin.er21@gmail.com','123456','0554 263 88 40','EHLFM774','2021-06-29 16:33:58'),
('Deniz','Bulut','deniz.bulut22@hotmail.com','123456','0551 744 22 19','EHLGB813','2021-07-18 21:17:00'),
('Kaan','Bozkurt','kaan.bozkurt23@gmail.com','123456','0555 093 45 88','EHLGH069','2021-08-05 10:26:40'),
('Burcu','Taş','burcu.tas24@hotmail.com','123456','0553 204 18 74','EHLGS247','2021-08-25 09:58:22'),
('Musa','Güneş','musa.gunes25@gmail.com','123456','0550 851 67 30','EHLGX901','2021-09-09 18:05:11'),
('Gizem','Çelik','gizem.celik26@hotmail.com','123456','0554 627 44 19','EHLHA223','2021-09-27 11:17:42'),
('Tuna','Ergin','tuna.ergin27@gmail.com','123456','0552 714 95 02','EHLHB799','2021-10-04 20:52:37'),
('Bora','Kılınç','bora.kilinc28@hotmail.com','123456','0551 306 82 41','EHLHC612','2021-10-22 14:09:01'),
('Eylül','Yaman','eylul.yaman29@gmail.com','123456','0554 998 53 77','EHLHM380','2021-11-03 15:33:22'),
('Hilal','Sağlam','hilal.saglam30@hotmail.com','123456','0553 120 45 63','EHLHZ956','2021-11-28 18:44:10'),
('Kübra','Aslan','kubra.aslan31@gmail.com','123456','0550 930 08 31','EHLID081','2022-01-07 12:05:48'),
('Serkan','Uzun','serkan.uzun32@hotmail.com','123456','0551 486 59 40','EHLIV277','2022-01-22 19:24:55'),
('Yağmur','Sevgi','yagmur.sevgi33@gmail.com','123456','0552 719 34 68','EHLJA144','2022-02-04 16:41:03'),
('Talha','Özdemir','talha.ozdemir34@hotmail.com','123456','0555 421 07 92','EHLJF640','2022-02-26 21:52:38'),
('Damla','Gür','damla.gur35@gmail.com','123456','0551 665 33 47','EHLJG221','2022-03-10 10:36:55'),
('Burak','Öztürk','burak.ozturk36@hotmail.com','123456','0554 237 92 10','EHLJT330','2022-03-28 22:39:42'),
('Merve','Altun','merve.altun37@gmail.com','123456','0553 792 16 85','EHLLA703','2022-04-06 08:59:13'),
('Arda','Işık','arda.isik38@hotmail.com','123456','0550 504 90 13','EHLLB520','2022-04-21 11:24:56'),
('Sena','Ateş','sena.ates39@gmail.com','123456','0551 988 44 72','EHLLE404','2022-05-12 15:42:18'),
('Eren','Özer','eren.ozer40@hotmail.com','123456','0552 361 08 97','EHLLM238','2022-06-01 09:58:44'),
('Yaren','Turan','yaren.turan41@gmail.com','123456','0555 154 22 06','EHLLX187','2022-06-29 17:22:01'),
('Hasan','Durmaz','hasan.durmaz42@hotmail.com','123456','0553 842 67 51','EHLLZ301','2022-07-16 20:44:12'),
('Neşe','Torun','nese.torun43@gmail.com','123456','0551 409 13 86','EHLMF420','2022-07-27 14:19:03'),
('Okan','Boz','okan.boz44@hotmail.com','123456','0550 272 40 19','EHLMK732','2022-08-15 11:57:50'),
('Dilara','Varol','dilara.varol45@gmail.com','123456','0552 764 99 04','EHLMN055','2022-08-29 16:49:28'),
('Batuhan','Eker','batuhan.eker46@hotmail.com','123456','0554 903 70 82','EHLMR880','2022-09-10 13:32:44'),
('Ufuk','Tetik','ufuk.tetik47@gmail.com','123456','0555 319 48 25','EHLMZ114','2022-09-26 21:58:08'),
('Betül','Acar','betul.acar48@hotmail.com','123456','0553 607 22 94','EHLNA541','2022-10-07 18:07:12'),
('Taner','Gök','taner.gok49@gmail.com','123456','0551 874 05 38','EHLNJ031','2022-10-23 10:29:37'),
('Nisanur','Keleş','nisanur.keles50@hotmail.com','123456','0550 638 17 66','EHLNK288','2022-11-12 20:40:52'),
('Kerem','Tan','kerem.tan51@gmail.com','123456','0552 725 34 10','EHLNN904','2023-01-04 14:28:44'),
('Beyza','Kalkan','beyza.kalkan52@hotmail.com','123456','0554 519 76 02','EHLNP667','2023-01-18 17:15:29'),
('Tolga','Bilgin','tolga.bilgin53@gmail.com','123456','0555 280 45 91','EHLNZ406','2023-02-07 20:59:46'),
('Zehra','Kurt','zehra.kurt54@hotmail.com','123456','0553 153 99 28','EHLPB019','2023-02-24 15:41:18'),
('Sinan','Güler','sinan.guler55@gmail.com','123456','0551 736 10 84','EHLPJ292','2023-03-09 11:32:55'),
('Pelinsu','Ersoy','pelinsu.ersoy56@hotmail.com','123456','0550 492 37 15','EHLPK507','2023-03-28 19:44:22'),
('Said','Kavak','said.kavak57@gmail.com','123456','0552 920 54 08','EHLPQ887','2023-04-03 09:58:11'),
('Tuğba','Uçar','tugba.ucar58@hotmail.com','123456','0554 648 75 39','EHLPX002','2023-04-25 21:22:42'),
('Yiğit','Tuna','yigit.tuna59@gmail.com','123456','0555 507 66 41','EHLQA773','2023-05-06 10:15:13'),
('Şule','Irlı','sule.irl60@hotmail.com','123456','0553 220 97 06','EHLQB622','2023-05-29 16:42:19'),
('Oğuz','Gören','oguz.goren61@gmail.com','123456','0551 945 33 18','EHLQE204','2023-06-14 21:58:02'),
('Aslı','Koral','asli.koral62@hotmail.com','123456','0550 713 05 49','EHLQH772','2023-06-27 14:33:44'),
('Berkay','Şimşek','berkay.simsek63@gmail.com','123456','0552 801 94 20','EHLQM441','2023-07-08 11:49:08'),
('Elçin','Gürler','elcin.gurler64@hotmail.com','123456','0554 988 50 37','EHLQS553','2023-07-22 18:28:51'),
('Ayhan','Soylu','ayhan.soylu65@gmail.com','123456','0555 379 84 92','EHLQV118','2023-08-05 20:49:37'),
('Mina','Gökçe','mina.gokce66@hotmail.com','123456','0553 146 22 58','EHLRA365','2023-08-21 12:41:12'),
('Yunus','Akyol','yunus.akyol67@gmail.com','123456','0551 624 79 01','EHLRD902','2023-09-03 09:33:52'),
('Dilan','Ertem','dilan.ertem68@hotmail.com','123456','0550 503 48 36','EHLRH113','2023-09-27 14:16:07'),
('Göktuğ','Çınar','goktug.cinar69@gmail.com','123456','0552 997 11 75','EHLRM784','2023-10-12 19:25:31'),
('Sibel','Yetkin','sibel.yetkin70@hotmail.com','123456','0554 764 39 04','EHLRX211','2023-10-29 21:57:03'),
('Harun','Erbay','harun.erbay71@gmail.com','123456','0555 645 20 88','EHLRY877','2024-01-08 13:41:40'),
('Nursel','Kaynar','nursel.kaynar72@hotmail.com','123456','0553 129 47 30','EHLSB038','2024-01-25 09:58:50'),
('Bahtiyar','Ölmez','bahtiyar.olmez73@gmail.com','123456','0551 706 83 95','EHLSD496','2024-02-10 16:33:29'),
('Mehmet','Tutku','mehmet.tutku74@hotmail.com','123456','0550 854 62 17','EHLSF739','2024-02-27 22:47:53'),
('Gül','Solmaz','gul.solmaz75@gmail.com','123456','0552 412 30 69','EHLSJ209','2024-03-09 14:25:41'),
('Kemal','Zengin','kemal.zengin76@hotmail.com','123456','0554 698 04 21','EHLSP992','2024-03-25 11:30:57'),
('Fatoş','Kar','fatos.kar77@gmail.com','123456','0555 587 93 46','EHLSS355','2024-04-12 19:58:16'),
('Burhan','Erinç','burhan.erinc78@hotmail.com','123456','0553 270 18 52','EHLST644','2024-04-27 17:43:29'),
('Seçil','Ateş','secil.ates79@gmail.com','123456','0551 935 71 08','EHLTA507','2024-05-18 10:55:13'),
('Volkan','Ertem','volkan.ertem80@hotmail.com','123456','0550 603 25 90','EHLTD883','2024-06-01 21:31:40'),
('Nehir','Var','nehir.var81@gmail.com','123456','0552 891 40 37','EHLTK221','2024-06-27 12:47:51'),
('Aydın','Bozan','aydin.bozan82@hotmail.com','123456','0554 305 69 14','EHLTP608','2024-07-11 15:39:33'),
('Eylül','Ören','eylul.oren83@gmail.com','123456','0555 718 92 46','EHLTX947','2024-07-29 10:13:50'),
('Hülya','Ege','hulya.ege84@hotmail.com','123456','0553 461 57 20','EHLUA302','2024-08-13 19:54:17'),
('Rıza','Kaplan','riza.kaplan85@gmail.com','123456','0551 826 03 79','EHLUC699','2024-09-02 11:29:48'),
('Sude','Kal','sude.kal86@hotmail.com','123456','0554 595 40 43','EHLXW518','2024-09-27 20:08:01'),
('Efe','Güçlü','efe.guclu87@gmail.com','123456','0550 728 03 72','EHLXY662','2024-10-11 18:55:22'),
('Mehtap','Ersin','mehtap.ersin88@hotmail.com','123456','0553 738 70 24','EHLYA677','2024-10-28 22:19:37'),
('Alper','Kalkan','alper.kalkan89@gmail.com','123456','0551 165 30 40','EHLYC035','2024-11-09 11:45:19'),
('Nur','Güray','nur.guray90@hotmail.com','123456','0555 845 18 89','EHLYE848','2024-11-26 13:50:53'),
('Halil','Tanju','halil.tanju91@gmail.com','123456','0552 439 60 81','EHLYG501','2025-01-03 15:24:11'),
('Murat','Eren','murat.eren92@hotmail.com','123456','0554 813 38 60','EHLYJ153','2025-01-21 11:33:40'),
('İlayda','Soylu','ilayda.soylu93@gmail.com','123456','0555 078 12 34','EHLYJ909','2025-02-07 12:49:26'),
('Çağrı','Durak','cagri.durak94@hotmail.com','123456','0553 705 98 97','EHLYM152','2025-02-27 18:35:59'),
('Pınar','Yalçın','pinar.yalcin95@gmail.com','123456','0551 375 57 19','EHLYZ638','2025-03-11 19:28:14'),
('Hüseyin','Göl','huseyin.gol96@hotmail.com','123456','0550 509 71 48','EHLZK920','2025-03-29 10:09:07'),
('Aysun','Keleş','aysun.keles97@gmail.com','123456','0554 555 86 67','EHLZN896','2025-04-12 22:58:32'),
('Tolunay','Sağ','tolunay.sag98@hotmail.com','123456','0552 738 12 88','EHLZO500','2025-04-26 08:57:55'),
('Esra','İlhan','esra.ilhan99@gmail.com','123456','0555 983 55 54','EHLZS368','2025-05-07 16:41:20'),
('Korel','Bilen','korel.bilen100@hotmail.com','123456','0559 872 02 15','EHLZX523','2025-05-26 14:19:44');

-- ===================
-- 2. OFİSLER 
-- ===================
CREATE TABLE Ofisler (
  OfisID INT AUTO_INCREMENT PRIMARY KEY,
  OfisAdi VARCHAR(100),
  Sehir VARCHAR(50),
  Adres TEXT,
  Telefon VARCHAR(15),
  Eposta VARCHAR(100) UNIQUE,
  SifreHash VARCHAR(255)
);


INSERT INTO Ofisler (OfisAdi, Sehir, Adres, Telefon, Eposta, SifreHash) VALUES
('Ankara Merkez Ofis', 'Ankara', 'Çankaya, Atatürk Bulvarı No:45 Kavaklıdere', '0312 450 12 34', 'ankara@rentdrive.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92'),
('İstanbul Avrupa Ofisi', 'İstanbul', 'Beşiktaş, Barbaros Bulvarı No:22', '0212 340 98 76', 'istanbul.avrupa@rentdrive.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92'),
('İstanbul Anadolu Ofisi', 'İstanbul', 'Kadıköy, Bağdat Caddesi No:180', '0216 555 44 33', 'istanbul.anadolu@rentdrive.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92'),
('İzmir Konak Ofisi', 'İzmir', 'Konak, Kordonboyu Mah. Sahil Cd. No:12', '0232 410 22 11', 'izmir@rentdrive.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92'),
('Antalya Lara Ofisi', 'Antalya', 'Lara, Güzeloba Mah. Özgürlük Cd. No:78', '0242 330 44 28', 'antalya@rentdrive.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92'),
('Bursa Nilüfer Ofisi', 'Bursa', 'Nilüfer, FSM Bulvarı No:55', '0224 360 77 55', 'bursa@rentdrive.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92'),
('Adana Seyhan Ofisi', 'Adana', 'Seyhan, Atatürk Cd. No:99', '0322 420 33 00', 'adana@rentdrive.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92'),
('Trabzon Meydan Ofisi', 'Trabzon', 'Ortahisar, Meydan Cd. No:8', '0462 321 45 65', 'trabzon@rentdrive.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92'),
('Gaziantep Şehitkamil Ofisi', 'Gaziantep', 'Şehitkamil, İnönü Cd. No:67', '0342 550 81 33', 'gaziantep@rentdrive.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92'),
('Eskişehir Tepebaşı Ofisi', 'Eskişehir', 'Tepebaşı, İsmet İnönü Cd. No:14', '0222 340 56 42', 'eskisehir@rentdrive.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92');

-- ===================
-- 3. ARAÇLAR (100 kayıt)
-- ===================
CREATE TABLE Araclar (
  AracID INT AUTO_INCREMENT PRIMARY KEY,
  Plaka VARCHAR(15) UNIQUE,
  Marka VARCHAR(50),
  Model VARCHAR(50),
  Yil SMALLINT,
  VitesTuru ENUM('Otomatik','Manuel'),
  YakitTipi ENUM('Benzin','Dizel','Elektrik','Hibrit'),
  GunlukKiraUcreti DECIMAL(10,2),
  MevcutOfisID INT,
  Durum ENUM('Müsait','Kirada','Bakımda'),
  FOREIGN KEY (MevcutOfisID) REFERENCES Ofisler(OfisID)
);

INSERT INTO Araclar (Plaka, Marka, Model, Yil, VitesTuru, YakitTipi, GunlukKiraUcreti, MevcutOfisID, Durum) VALUES
-- Ankara Merkez Ofis (1) - 10 araç
('06 ANK 101', 'Toyota',      'Corolla',      2020, 'Otomatik', 'Benzin',   1100.00, 1, 'Müsait'),
('06 ANK 102', 'Renault',     'Clio',         2019, 'Manuel',   'Benzin',    850.00, 1, 'Müsait'),
('06 ANK 103', 'Volkswagen',  'Golf',         2021, 'Otomatik', 'Dizel',    1400.00, 1, 'Müsait'),
('06 ANK 104', 'Hyundai',     'i20',          2022, 'Otomatik', 'Hibrit',   1250.00, 1, 'Bakımda'),
('06 ANK 105', 'BMW',         '320i',         2020, 'Otomatik', 'Benzin',   2200.00, 1, 'Müsait'),
('06 ANK 106', 'Fiat',        'Egea',         2018, 'Manuel',   'Dizel',     750.00, 1, 'Müsait'),
('06 ANK 107', 'Skoda',       'Octavia',      2019, 'Otomatik', 'Dizel',    1250.00, 1, 'Müsait'),
('06 ANK 108', 'Honda',       'Civic',        2021, 'Otomatik', 'Benzin',   1350.00, 1, 'Müsait'),
('06 ANK 109', 'Dacia',       'Duster',       2018, 'Manuel',   'Dizel',     900.00, 1, 'Müsait'),
('06 ANK 110', 'Tesla',       'Model 3',      2023, 'Otomatik', 'Elektrik', 2900.00, 1, 'Müsait'),
-- İstanbul Avrupa Ofisi (2) - 10 araç
('34 AVP 201', 'Mercedes',    'C200',         2021, 'Otomatik', 'Benzin',   2400.00, 2, 'Müsait'),
('34 AVP 202', 'Fiat',        'Egea',         2017, 'Manuel',   'Benzin',    700.00, 2, 'Müsait'),
('34 AVP 203', 'Opel',        'Astra',        2019, 'Manuel',   'Benzin',    900.00, 2, 'Müsait'),
('34 AVP 204', 'Peugeot',     '3008',         2021, 'Otomatik', 'Dizel',    1600.00, 2, 'Müsait'),
('34 AVP 205', 'Tesla',       'Model Y',      2024, 'Otomatik', 'Elektrik', 3100.00, 2, 'Bakımda'),
('34 AVP 206', 'Volkswagen',  'Passat',       2020, 'Otomatik', 'Dizel',    1700.00, 2, 'Müsait'),
('34 AVP 207', 'Toyota',      'Yaris',        2018, 'Manuel',   'Benzin',    750.00, 2, 'Müsait'),
('34 AVP 208', 'BMW',         '520d',         2020, 'Otomatik', 'Dizel',    2600.00, 2, 'Müsait'),
('34 AVP 209', 'Hyundai',     'Elantra',      2021, 'Otomatik', 'Benzin',   1200.00, 2, 'Müsait'),
('34 AVP 210', 'Renault',     'Megane',       2019, 'Otomatik', 'Dizel',    1350.00, 2, 'Müsait'),
-- İstanbul Anadolu Ofisi (3) - 10 araç
('34 AND 301', 'Toyota',      'Auris',        2017, 'Manuel',   'Benzin',    750.00, 3, 'Müsait'),
('34 AND 302', 'Honda',       'Civic',        2020, 'Otomatik', 'Benzin',   1300.00, 3, 'Müsait'),
('34 AND 303', 'Skoda',       'Octavia',      2019, 'Otomatik', 'Dizel',    1250.00, 3, 'Müsait'),
('34 AND 304', 'Nissan',      'Qashqai',      2022, 'Otomatik', 'Benzin',   1700.00, 3, 'Müsait'),
('34 AND 305', 'Volkswagen',  'Passat',       2021, 'Otomatik', 'Dizel',    1600.00, 3, 'Bakımda'),
('34 AND 306', 'Fiat',        'Panda',        2016, 'Manuel',   'Benzin',    650.00, 3, 'Müsait'),
('34 AND 307', 'Dacia',       'Sandero',      2018, 'Manuel',   'Benzin',    700.00, 3, 'Müsait'),
('34 AND 308', 'Peugeot',     '208',          2019, 'Manuel',   'Benzin',    800.00, 3, 'Müsait'),
('34 AND 309', 'BMW',         '118i',         2019, 'Otomatik', 'Benzin',   1800.00, 3, 'Müsait'),
('34 AND 310', 'Tesla',       'Model S',      2023, 'Otomatik', 'Elektrik', 3200.00, 3, 'Müsait'),
-- İzmir Konak Ofisi (4) - 10 araç
('35 IZM 401', 'Renault',     'Megane',       2020, 'Otomatik', 'Dizel',    1400.00, 4, 'Müsait'),
('35 IZM 402', 'Toyota',      'Corolla',      2018, 'Manuel',   'Benzin',    900.00, 4, 'Müsait'),
('35 IZM 403', 'Hyundai',     'Elantra',      2021, 'Otomatik', 'Benzin',   1200.00, 4, 'Müsait'),
('35 IZM 404', 'Peugeot',     '3008',         2020, 'Otomatik', 'Dizel',    1550.00, 4, 'Müsait'),
('35 IZM 405', 'BMW',         'X1',           2020, 'Otomatik', 'Dizel',    2100.00, 4, 'Bakımda'),
('35 IZM 406', 'Volkswagen',  'Golf',         2019, 'Manuel',   'Benzin',   1000.00, 4, 'Müsait'),
('35 IZM 407', 'Fiat',        'Egea',         2017, 'Manuel',   'Dizel',     750.00, 4, 'Müsait'),
('35 IZM 408', 'Honda',       'Jazz',         2018, 'Manuel',   'Benzin',    800.00, 4, 'Müsait'),
('35 IZM 409', 'Mercedes',    'A180',         2021, 'Otomatik', 'Benzin',   2000.00, 4, 'Müsait'),
('35 IZM 410', 'Tesla',       'Model 3',      2022, 'Otomatik', 'Elektrik', 2850.00, 4, 'Müsait'),
-- Antalya Lara Ofisi (5) - 10 araç
('07 ANT 501', 'Dacia',       'Duster',       2019, 'Manuel',   'Dizel',     900.00, 5, 'Müsait'),
('07 ANT 502', 'Hyundai',     'Tucson',       2022, 'Otomatik', 'Benzin',   1800.00, 5, 'Müsait'),
('07 ANT 503', 'Renault',     'Captur',       2020, 'Otomatik', 'Benzin',   1100.00, 5, 'Müsait'),
('07 ANT 504', 'Toyota',      'CH-R',         2021, 'Otomatik', 'Hibrit',   1600.00, 5, 'Müsait'),
('07 ANT 505', 'Volkswagen',  'T-Roc',        2022, 'Otomatik', 'Benzin',   1750.00, 5, 'Bakımda'),
('07 ANT 506', 'Fiat',        'Egea',         2018, 'Manuel',   'Dizel',     750.00, 5, 'Müsait'),
('07 ANT 507', 'Skoda',       'Karoq',        2021, 'Otomatik', 'Dizel',    1650.00, 5, 'Müsait'),
('07 ANT 508', 'Peugeot',     '2008',         2020, 'Otomatik', 'Dizel',    1400.00, 5, 'Müsait'),
('07 ANT 509', 'Honda',       'CR-V',         2021, 'Otomatik', 'Benzin',   1900.00, 5, 'Müsait'),
('07 ANT 510', 'BMW',         'X3',           2022, 'Otomatik', 'Dizel',    2500.00, 5, 'Müsait'),
-- Bursa Nilüfer Ofisi (6) - 10 araç
('16 BRS 601', 'Fiat',        'Panda',        2016, 'Manuel',   'Benzin',    650.00, 6, 'Müsait'),
('16 BRS 602', 'Skoda',       'Superb',       2020, 'Otomatik', 'Dizel',    1500.00, 6, 'Müsait'),
('16 BRS 603', 'Honda',       'Jazz',         2018, 'Manuel',   'Benzin',    800.00, 6, 'Müsait'),
('16 BRS 604', 'Hyundai',     'i30',          2020, 'Otomatik', 'Benzin',   1100.00, 6, 'Müsait'),
('16 BRS 605', 'Tesla',       'Model Y',      2024, 'Otomatik', 'Elektrik', 3000.00, 6, 'Bakımda'),
('16 BRS 606', 'Volkswagen',  'Golf',         2019, 'Manuel',   'Benzin',   1000.00, 6, 'Müsait'),
('16 BRS 607', 'Renault',     'Fluence',      2017, 'Manuel',   'Dizel',     850.00, 6, 'Müsait'),
('16 BRS 608', 'Toyota',      'Corolla',      2018, 'Otomatik', 'Benzin',   1150.00, 6, 'Müsait'),
('16 BRS 609', 'Mercedes',    'CLA 180',      2020, 'Otomatik', 'Benzin',   2300.00, 6, 'Müsait'),
('16 BRS 610', 'BMW',         '320d',         2021, 'Otomatik', 'Dizel',    2400.00, 6, 'Müsait'),
-- Adana Seyhan Ofisi (7) - 10 araç
('01 ADN 701', 'Renault',     'Talisman',     2019, 'Otomatik', 'Dizel',    1500.00, 7, 'Müsait'),
('01 ADN 702', 'Fiat',        'Linea',        2018, 'Manuel',   'Benzin',    700.00, 7, 'Müsait'),
('01 ADN 703', 'Peugeot',     '508',          2020, 'Otomatik', 'Dizel',    1700.00, 7, 'Müsait'),
('01 ADN 704', 'Toyota',      'Camry',        2021, 'Otomatik', 'Benzin',   2000.00, 7, 'Bakımda'),
('01 ADN 705', 'Hyundai',     'Kona',         2022, 'Otomatik', 'Elektrik', 2300.00, 7, 'Müsait'),
('01 ADN 706', 'Volkswagen',  'Jetta',        2017, 'Manuel',   'Benzin',    900.00, 7, 'Müsait'),
('01 ADN 707', 'Dacia',       'Logan',        2016, 'Manuel',   'Benzin',    650.00, 7, 'Müsait'),
('01 ADN 708', 'Opel',        'Corsa',        2018, 'Manuel',   'Benzin',    750.00, 7, 'Müsait'),
('01 ADN 709', 'Honda',       'City',         2019, 'Otomatik', 'Benzin',   1050.00, 7, 'Müsait'),
('01 ADN 710', 'Mercedes',    'GLA 200',      2022, 'Otomatik', 'Benzin',   2500.00, 7, 'Müsait'),
-- Trabzon Meydan Ofisi (8) - 10 araç
('61 TRB 801', 'Volkswagen',  'Tiguan',       2021, 'Otomatik', 'Dizel',    1900.00, 8, 'Müsait'),
('61 TRB 802', 'Toyota',      'RAV4',         2020, 'Otomatik', 'Hibrit',   2100.00, 8, 'Müsait'),
('61 TRB 803', 'Honda',       'HR-V',         2019, 'Otomatik', 'Benzin',   1300.00, 8, 'Müsait'),
('61 TRB 804', 'Dacia',       'Sandero',      2018, 'Manuel',   'Benzin',    750.00, 8, 'Müsait'),
('61 TRB 805', 'BMW',         'X3',           2022, 'Otomatik', 'Dizel',    2500.00, 8, 'Bakımda'),
('61 TRB 806', 'Renault',     'Kadjar',       2019, 'Otomatik', 'Benzin',   1300.00, 8, 'Müsait'),
('61 TRB 807', 'Hyundai',     'Bayon',        2021, 'Otomatik', 'Benzin',   1200.00, 8, 'Müsait'),
('61 TRB 808', 'Peugeot',     '3008',         2020, 'Otomatik', 'Dizel',    1550.00, 8, 'Müsait'),
('61 TRB 809', 'Fiat',        'Egea',         2018, 'Manuel',   'Dizel',     750.00, 8, 'Müsait'),
('61 TRB 810', 'Tesla',       'Model 3',      2023, 'Otomatik', 'Elektrik', 2900.00, 8, 'Müsait'),
-- Gaziantep Şehitkamil Ofisi (9) - 10 araç
('27 GZT 901', 'Renault',     'Clio',         2019, 'Manuel',   'Benzin',    850.00, 9, 'Müsait'),
('27 GZT 902', 'Hyundai',     'Elantra',      2021, 'Otomatik', 'Benzin',   1200.00, 9, 'Müsait'),
('27 GZT 903', 'Peugeot',     '2008',         2022, 'Otomatik', 'Dizel',    1400.00, 9, 'Müsait'),
('27 GZT 904', 'Toyota',      'Corolla',      2020, 'Manuel',   'Benzin',    950.00, 9, 'Müsait'),
('27 GZT 905', 'Volkswagen',  'Golf',         2021, 'Otomatik', 'Dizel',    1500.00, 9, 'Bakımda'),
('27 GZT 906', 'Fiat',        'Tipo',         2018, 'Manuel',   'Dizel',     800.00, 9, 'Müsait'),
('27 GZT 907', 'Opel',        'Insignia',     2019, 'Otomatik', 'Dizel',    1600.00, 9, 'Müsait'),
('27 GZT 908', 'Dacia',       'Duster',       2018, 'Manuel',   'Dizel',     900.00, 9, 'Müsait'),
('27 GZT 909', 'Honda',       'Civic',        2020, 'Otomatik', 'Benzin',   1300.00, 9, 'Müsait'),
('27 GZT 910', 'BMW',         '320i',         2021, 'Otomatik', 'Benzin',   2200.00, 9, 'Müsait'),
-- Eskişehir Tepebaşı Ofisi (10) - 10 araç
('26 ESK 001', 'Fiat',        'Egea',         2018, 'Manuel',   'Dizel',     750.00, 10, 'Müsait'),
('26 ESK 002', 'Toyota',      'Auris',        2017, 'Manuel',   'Benzin',    700.00, 10, 'Müsait'),
('26 ESK 003', 'Hyundai',     'i20',          2022, 'Otomatik', 'Hibrit',   1250.00, 10, 'Müsait'),
('26 ESK 004', 'BMW',         '118i',         2019, 'Otomatik', 'Benzin',   1800.00, 10, 'Müsait'),
('26 ESK 005', 'Tesla',       'Model S',      2023, 'Otomatik', 'Elektrik', 3200.00, 10, 'Bakımda'),
('26 ESK 006', 'Renault',     'Megane',       2019, 'Otomatik', 'Dizel',    1400.00, 10, 'Müsait'),
('26 ESK 007', 'Volkswagen',  'Golf',         2018, 'Manuel',   'Benzin',    950.00, 10, 'Müsait'),
('26 ESK 008', 'Opel',        'Astra',        2018, 'Manuel',   'Benzin',    900.00, 10, 'Müsait'),
('26 ESK 009', 'Peugeot',     '301',          2017, 'Manuel',   'Dizel',     800.00, 10, 'Müsait'),
('26 ESK 010', 'Mercedes',    'C180',         2020, 'Otomatik', 'Benzin',   2300.00, 10, 'Müsait');

-- ===================
-- 4. REZERVASYONLAR 
-- ===================
CREATE TABLE Rezervasyonlar (
  RezervasyonID INT AUTO_INCREMENT PRIMARY KEY,
  KullaniciID INT,
  AracID INT,
  AlisOfisID INT,
  TeslimOfisID INT,
  AlisTarihi DATE,
  TeslimTarihi DATE,
  ToplamUcret DECIMAL(10,2),
  Durum ENUM('Beklemede', 'Onaylandı', 'Devam Ediyor', 'İptal Edildi', 'Tamamlandı') DEFAULT 'Beklemede',
  FOREIGN KEY (KullaniciID) REFERENCES Kullanicilar(KullaniciID),
  FOREIGN KEY (AracID) REFERENCES Araclar(AracID),
  FOREIGN KEY (AlisOfisID) REFERENCES Ofisler(OfisID),
  FOREIGN KEY (TeslimOfisID) REFERENCES Ofisler(OfisID)
);

INSERT INTO Rezervasyonlar (KullaniciID, AracID, AlisOfisID, TeslimOfisID, AlisTarihi, TeslimTarihi, ToplamUcret, Durum) VALUES
(82, 15, 2, 2, '2022-09-30', '2022-10-04', 7600.00, 'Tamamlandı'),
(14, 87, 9, 7, '2020-05-10', '2020-05-11', 1100.00, 'Tamamlandı'),
(30, 65, 7, 4, '2024-09-14', '2024-09-18', 2000.00, 'Tamamlandı'),
(36, 1, 1, 1, '2023-10-25', '2023-10-30', 5500.00, 'Tamamlandı'),
(98, 44, 5, 5, '2024-01-10', '2024-01-24', 22400.00, 'Tamamlandı'),
(34, 6, 1, 1, '2024-03-30', '2024-04-01', 1500.00, 'Tamamlandı'),
(81, 80, 8, 8, '2020-10-11', '2020-10-12', 1550.00, 'Tamamlandı'),
(99, 38, 4, 4, '2021-02-17', '2021-02-24', 5600.00, 'Tamamlandı'),
(82, 47, 5, 5, '2022-05-08', '2022-05-19', 18150.00, 'Tamamlandı'),
(88, 83, 9, 9, '2021-12-01', '2021-12-10', 11700.00, 'İptal Edildi'),
(21, 60, 6, 6, '2022-06-18', '2022-06-29', 11000.00, 'Tamamlandı'),
(99, 100, 10, 10, '2023-07-16', '2023-07-23', 16100.00, 'Tamamlandı'),
(28, 73, 8, 8, '2024-06-08', '2024-06-19', 14300.00, 'Tamamlandı'),
(34, 18, 2, 2, '2023-08-03', '2023-08-09', 15600.00, 'Tamamlandı'),
(86, 8, 1, 1, '2022-12-15', '2022-12-22', 9450.00, 'Tamamlandı'),
(94, 81, 8, 8, '2021-10-30', '2021-11-02', 5700.00, 'Tamamlandı'),
(69, 95, 10, 10, '2022-07-27', '2022-08-08', 11400.00, 'Tamamlandı'),
(11, 41, 5, 5, '2020-09-11', '2020-09-17', 5400.00, 'Tamamlandı'),
(75, 84, 9, 9, '2022-03-25', '2022-04-06', 10800.00, 'Tamamlandı'),
(54, 84, 9, 9, '2022-11-21', '2022-11-22', 900.00, 'Tamamlandı'),
(4, 74, 8, 8, '2023-08-28', '2023-09-07', 21000.00, 'Tamamlandı'),
(3, 3, 1, 1, '2023-04-18', '2023-04-23', 7000.00, 'Tamamlandı'),
(11, 64, 7, 7, '2023-07-17', '2023-07-31', 30000.00, 'Tamamlandı'),
(27, 58, 6, 6, '2022-03-26', '2022-04-06', 12650.00, 'Tamamlandı'),
(29, 75, 8, 8, '2020-02-08', '2020-02-16', 12000.00, 'Tamamlandı'),
(64, 90, 9, 9, '2023-04-21', '2023-04-26', 6500.00, 'Tamamlandı'),
(13, 32, 4, 4, '2024-09-17', '2024-09-29', 10800.00, 'Tamamlandı'),
(19, 5, 1, 1, '2021-02-06', '2021-02-09', 6600.00, 'Tamamlandı'),
(71, 13, 2, 2, '2022-03-07', '2022-03-12', 4500.00, 'Tamamlandı'),
(35, 23, 3, 3, '2020-03-23', '2020-03-26', 3750.00, 'Tamamlandı'),
(71, 71, 8, 8, '2021-03-25', '2021-03-30', 9500.00, 'İptal Edildi'),
(12, 30, 4, 4, '2024-05-29', '2024-06-07', 12600.00, 'Tamamlandı'),
(44, 23, 3, 3, '2022-07-03', '2022-07-08', 6250.00, 'Tamamlandı'),
(89, 93, 10, 10, '2020-10-03', '2020-10-14', 13750.00, 'Tamamlandı'),
(52, 2, 1, 1, '2023-01-17', '2023-01-23', 5100.00, 'Tamamlandı'),
(15, 58, 6, 6, '2024-10-01', '2024-10-13', 13800.00, 'Tamamlandı'),
(95, 40, 5, 5, '2024-10-10', '2024-10-12', 2800.00, 'Tamamlandı'),
(78, 66, 7, 7, '2021-08-23', '2021-08-30', 4550.00, 'Tamamlandı'),
(4, 14, 2, 2, '2024-06-09', '2024-06-14', 8000.00, 'Tamamlandı'),
(72, 45, 5, 5, '2023-01-19', '2023-01-31', 21600.00, 'Tamamlandı'),
(26, 52, 6, 6, '2023-09-19', '2023-09-27', 12000.00, 'Tamamlandı'),
(43, 94, 10, 10, '2023-06-21', '2023-06-22', 950.00, 'Tamamlandı'),
(32, 62, 7, 7, '2023-11-20', '2023-11-21', 700.00, 'Tamamlandı'),
(15, 46, 5, 5, '2022-02-23', '2022-03-04', 15750.00, 'İptal Edildi'),
(82, 70, 7, 7, '2020-10-03', '2020-10-09', 9000.00, 'Tamamlandı'),
(2, 42, 5, 5, '2024-07-28', '2024-08-08', 19800.00, 'Tamamlandı'),
(94, 27, 3, 3, '2021-01-21', '2021-01-27', 4200.00, 'Tamamlandı'),
(33, 40, 5, 5, '2024-07-18', '2024-07-20', 2800.00, 'Tamamlandı'),
(93, 50, 6, 6, '2021-03-22', '2021-04-03', 18000.00, 'Tamamlandı'),
(40, 60, 6, 6, '2023-05-21', '2023-05-26', 5500.00, 'Tamamlandı'),
(43, 79, 8, 8, '2021-05-09', '2021-05-18', 11700.00, 'Tamamlandı'),
(73, 6, 1, 1, '2024-03-01', '2024-03-03', 1500.00, 'Tamamlandı'),
(84, 35, 4, 4, '2023-01-19', '2023-01-28', 18900.00, 'Tamamlandı'),
(79, 70, 7, 7, '2021-09-30', '2021-10-02', 3000.00, 'Tamamlandı'),
(11, 47, 5, 5, '2024-03-30', '2024-04-02', 4950.00, 'Tamamlandı'),
(78, 52, 6, 6, '2024-08-01', '2024-08-11', 15000.00, 'Tamamlandı'),
(18, 90, 9, 9, '2021-08-02', '2021-08-07', 6500.00, 'Tamamlandı'),
(99, 47, 5, 5, '2020-12-06', '2020-12-10', 6600.00, 'Tamamlandı'),
(30, 59, 6, 6, '2021-06-13', '2021-06-24', 25300.00, 'Tamamlandı'),
(89, 70, 7, 7, '2020-04-07', '2020-04-14', 10500.00, 'Tamamlandı'),
(4, 22, 3, 3, '2023-05-25', '2023-06-02', 10400.00, 'Tamamlandı'),
(37, 75, 8, 8, '2020-04-07', '2020-04-11', 6000.00, 'Tamamlandı'),
(58, 26, 3, 3, '2021-06-18', '2021-06-19', 650.00, 'Tamamlandı'),
(46, 84, 9, 9, '2024-08-19', '2024-08-29', 9000.00, 'Tamamlandı'),
(12, 20, 2, 2, '2024-08-13', '2024-08-23', 13500.00, 'Tamamlandı'),
(89, 31, 4, 4, '2022-07-22', '2022-07-29', 9800.00, 'Tamamlandı'),
(80, 52, 6, 6, '2024-12-27', '2025-01-04', 12000.00, 'İptal Edildi'),
(16, 43, 5, 5, '2020-11-06', '2020-11-18', 13200.00, 'Tamamlandı'),
(29, 32, 4, 4, '2024-07-26', '2024-08-05', 9000.00, 'Tamamlandı'),
(92, 97, 10, 10, '2020-01-18', '2020-01-29', 11550.00, 'Tamamlandı'),
(57, 12, 2, 2, '2022-09-12', '2022-09-26', 9800.00, 'Tamamlandı'),
(37, 58, 6, 6, '2021-11-13', '2021-11-25', 13800.00, 'Tamamlandı'),
(10, 18, 2, 2, '2023-07-10', '2023-07-18', 20800.00, 'Tamamlandı'),
(32, 6, 1, 1, '2022-10-14', '2022-10-21', 5250.00, 'İptal Edildi'),
(94, 20, 2, 2, '2020-11-18', '2020-11-26', 10800.00, 'Tamamlandı'),
(79, 48, 5, 5, '2024-08-06', '2024-08-07', 1400.00, 'Tamamlandı'),
(65, 77, 8, 8, '2021-01-16', '2021-01-25', 6750.00, 'Tamamlandı'),
(75, 71, 8, 8, '2021-07-05', '2021-07-08', 5700.00, 'İptal Edildi'),
(7, 57, 6, 6, '2024-09-09', '2024-09-22', 11050.00, 'Tamamlandı'),
(100, 64, 7, 7, '2022-06-18', '2022-06-29', 22000.00, 'Tamamlandı'),
(36, 19, 2, 2, '2023-01-03', '2023-01-14', 14850.00, 'Tamamlandı'),
(4, 85, 9, 9, '2021-12-26', '2022-01-09', 19600.00, 'Tamamlandı'),
(23, 8, 1, 1, '2022-10-14', '2022-10-18', 5400.00, 'Tamamlandı'),
(7, 7, 1, 1, '2021-10-01', '2021-10-06', 6250.00, 'Tamamlandı'),
(35, 79, 8, 8, '2024-10-28', '2024-11-04', 10850.00, 'Tamamlandı'),
(42, 57, 6, 6, '2023-02-05', '2023-02-16', 9350.00, 'Tamamlandı'),
(22, 64, 7, 7, '2024-08-11', '2024-08-19', 16000.00, 'Tamamlandı'),
(19, 59, 6, 6, '2021-06-27', '2021-06-29', 4600.00, 'Tamamlandı'),
(19, 64, 7, 7, '2022-11-08', '2022-11-21', 26000.00, 'Tamamlandı'),
(45, 72, 8, 8, '2023-11-16', '2023-11-24', 16800.00, 'Tamamlandı'),
(99, 15, 2, 2, '2021-10-29', '2021-11-11', 40300.00, 'Tamamlandı'),
(89, 17, 2, 2, '2022-08-03', '2022-08-11', 6000.00, 'Tamamlandı'),
(28, 25, 3, 3, '2024-07-04', '2024-07-12', 11200.00, 'Tamamlandı'),
(99, 74, 8, 8, '2023-09-08', '2023-09-11', 3900.00, 'Tamamlandı'),
(62, 36, 4, 4, '2024-02-22', '2024-02-28', 6000.00, 'Tamamlandı'),
(65, 74, 8, 8, '2021-11-14', '2021-11-27', 16900.00, 'Tamamlandı'),
(83, 25, 3, 3, '2024-08-20', '2024-08-27', 9800.00, 'Tamamlandı'),
(89, 15, 2, 2, '2020-06-16', '2020-06-21', 15500.00, 'Tamamlandı'),
(76, 52, 6, 6, '2024-06-05', '2024-06-16', 16500.00, 'Tamamlandı'),
(51, 47, 5, 5, '2022-10-22', '2022-10-25', 4950.00, 'Tamamlandı'),
(15, 6, 1, 1, '2023-06-21', '2023-06-26', 3750.00, 'Tamamlandı'),
(43, 57, 6, 6, '2020-11-21', '2020-11-23', 1700.00, 'Tamamlandı'),
(59, 76, 8, 8, '2021-07-30', '2021-08-03', 5200.00, 'Tamamlandı'),
(79, 16, 2, 2, '2023-01-16', '2023-01-24', 13600.00, 'Tamamlandı'),
(63, 91, 9, 9, '2024-08-06', '2024-08-14', 6800.00, 'Tamamlandı'),
(6, 43, 5, 5, '2021-04-01', '2021-04-13', 13200.00, 'Tamamlandı'),
(80, 22, 3, 3, '2024-10-10', '2024-10-17', 9100.00, 'Tamamlandı'),
(23, 63, 7, 7, '2024-06-12', '2024-06-18', 10200.00, 'Tamamlandı'),
(52, 16, 2, 2, '2020-06-08', '2020-06-10', 3400.00, 'Tamamlandı'),
(10, 44, 5, 5, '2021-08-19', '2021-08-29', 18000.00, 'Tamamlandı'),
(100, 59, 6, 6, '2022-02-08', '2022-02-13', 11500.00, 'Tamamlandı'),
(67, 28, 3, 3, '2020-12-28', '2021-01-09', 9600.00, 'Tamamlandı'),
(42, 2, 1, 1, '2024-01-21', '2024-01-24', 2550.00, 'Tamamlandı'),
(41, 14, 2, 2, '2023-03-16', '2023-03-24', 12800.00, 'Tamamlandı'),
(81, 12, 2, 2, '2024-12-10', '2024-12-16', 4200.00, 'Onaylandı'),
(9, 37, 4, 4, '2022-09-01', '2022-09-14', 10500.00, 'Tamamlandı'),
(85, 40, 5, 5, '2021-03-24', '2021-04-05', 16800.00, 'Tamamlandı'),
(3, 20, 2, 2, '2024-01-02', '2024-01-16', 18900.00, 'Tamamlandı'),
(38, 62, 7, 7, '2024-11-30', '2024-12-02', 1400.00, 'Tamamlandı'),
(84, 53, 6, 6, '2021-01-31', '2021-02-06', 4800.00, 'Tamamlandı'),
(42, 24, 3, 3, '2022-10-27', '2022-11-03', 11900.00, 'Tamamlandı'),
(45, 96, 10, 10, '2021-06-08', '2021-06-11', 2850.00, 'Tamamlandı'),
(18, 79, 8, 8, '2025-12-13', '2025-12-15', 3100.00, 'Onaylandı'),
(16, 76, 8, 8, '2022-11-03', '2022-11-10', 9100.00, 'Tamamlandı'),
(63, 60, 6, 6, '2022-08-28', '2022-09-03', 6600.00, 'Tamamlandı'),
(44, 87, 9, 9, '2020-08-17', '2020-08-19', 1600.00, 'Tamamlandı'),
(46, 41, 5, 5, '2022-09-04', '2022-09-06', 1800.00, 'Tamamlandı'),
(92, 3, 1, 1, '2021-01-30', '2021-02-02', 4200.00, 'Tamamlandı'),
(27, 53, 6, 6, '2024-09-26', '2024-10-01', 4000.00, 'Tamamlandı'),
(50, 41, 5, 5, '2021-04-12', '2021-04-15', 2700.00, 'Tamamlandı'),
(76, 60, 6, 6, '2024-11-02', '2024-11-05', 3300.00, 'İptal Edildi'),
(28, 90, 9, 9, '2022-11-06', '2022-11-07', 1300.00, 'Tamamlandı'),
(9, 4, 1, 1, '2020-02-13', '2020-02-24', 13750.00, 'Tamamlandı'),
(42, 38, 4, 4, '2023-09-12', '2023-09-16', 3200.00, 'Tamamlandı'),
(79, 43, 5, 5, '2021-07-04', '2021-07-08', 4400.00, 'Tamamlandı'),
(49, 86, 9, 9, '2020-01-15', '2020-01-24', 7200.00, 'Tamamlandı'),
(5, 37, 4, 4, '2020-06-08', '2020-06-14', 4500.00, 'Tamamlandı'),
(99, 79, 8, 8, '2021-10-13', '2021-10-23', 15500.00, 'Tamamlandı'),
(32, 55, 6, 6, '2023-04-19', '2023-04-22', 4500.00, 'İptal Edildi'),
(63, 98, 10, 10, '2021-10-30', '2021-11-05', 5400.00, 'Tamamlandı'),
(28, 34, 4, 4, '2021-06-14', '2021-06-27', 20150.00, 'Tamamlandı'),
(52, 72, 8, 8, '2024-09-25', '2024-10-01', 12600.00, 'Tamamlandı'),
(75, 84, 9, 9, '2023-10-26', '2023-10-29', 2700.00, 'Tamamlandı'),
(89, 38, 4, 4, '2022-09-14', '2022-09-19', 4000.00, 'Tamamlandı'),
(80, 46, 5, 5, '2024-07-05', '2024-07-06', 1650.00, 'Tamamlandı'),
(6, 64, 7, 7, '2020-05-23', '2020-06-01', 18000.00, 'Tamamlandı'),
(19, 92, 10, 10, '2023-11-01', '2023-11-06', 6250.00, 'Tamamlandı'),
(42, 26, 3, 3, '2023-03-19', '2023-03-23', 2600.00, 'Tamamlandı'),
(11, 97, 10, 10, '2020-03-20', '2020-03-26', 5700.00, 'Tamamlandı'),
(47, 87, 9, 9, '2020-04-28', '2020-05-02', 3200.00, 'Tamamlandı'),
(31, 40, 5, 5, '2022-06-18', '2022-06-22', 5600.00, 'İptal Edildi'),
(75, 26, 3, 3, '2024-11-14', '2024-11-22', 5200.00, 'Tamamlandı'),
(4, 31, 4, 4, '2024-12-22', '2024-12-29', 9800.00, 'Onaylandı'),
(89, 91, 9, 9, '2022-08-01', '2022-08-02', 850.00, 'Tamamlandı'),
(93, 64, 7, 7, '2020-06-27', '2020-07-11', 28000.00, 'Tamamlandı'),
(53, 83, 9, 9, '2023-09-09', '2023-09-14', 6500.00, 'Tamamlandı'),
(68, 35, 4, 4, '2020-02-01', '2020-02-02', 2100.00, 'Tamamlandı'),
(71, 49, 5, 5, '2024-04-29', '2024-05-01', 3300.00, 'Tamamlandı'),
(57, 78, 8, 8, '2024-12-01', '2024-12-06', 7750.00, 'Onaylandı'),
(69, 49, 5, 5, '2021-04-27', '2021-05-06', 14850.00, 'Tamamlandı'),
(33, 9, 1, 1, '2021-11-09', '2021-11-12', 2700.00, 'Tamamlandı'),
(50, 32, 4, 4, '2024-08-26', '2024-08-31', 4500.00, 'Tamamlandı'),
(61, 19, 2, 2, '2020-10-24', '2020-10-26', 2700.00, 'Tamamlandı'),
(32, 39, 4, 4, '2023-03-29', '2023-04-05', 8400.00, 'Tamamlandı'),
(98, 27, 3, 3, '2024-05-12', '2024-05-19', 4900.00, 'Tamamlandı'),
(23, 94, 10, 10, '2024-06-18', '2024-06-29', 10450.00, 'Tamamlandı'),
(79, 29, 3, 3, '2023-12-03', '2023-12-10', 12600.00, 'Tamamlandı'),
(21, 77, 8, 8, '2020-03-05', '2020-03-14', 13500.00, 'Tamamlandı'),
(7, 94, 10, 10, '2024-01-04', '2024-01-14', 9500.00, 'Tamamlandı'),
(76, 50, 6, 6, '2021-12-01', '2021-12-05', 6000.00, 'İptal Edildi'),
(9, 10, 1, 1, '2025-12-23', '2025-12-30', 20300.00, 'Onaylandı'),
(81, 60, 6, 6, '2024-03-26', '2024-03-30', 4400.00, 'Tamamlandı'),
(89, 87, 9, 9, '2020-07-15', '2020-07-23', 6400.00, 'Tamamlandı'),
(17, 81, 8, 8, '2020-01-03', '2020-01-09', 11400.00, 'Tamamlandı'),
(67, 13, 2, 2, '2022-09-24', '2022-10-04', 9000.00, 'Tamamlandı'),
(74, 45, 5, 5, '2023-03-10', '2023-03-16', 9900.00, 'Tamamlandı'),
(53, 87, 9, 9, '2022-09-02', '2022-09-04', 1600.00, 'Tamamlandı'),
(93, 69, 7, 7, '2020-09-28', '2020-10-02', 4200.00, 'Tamamlandı'),
(66, 9, 1, 1, '2022-08-28', '2022-09-02', 4500.00, 'Tamamlandı'),
(92, 16, 2, 2, '2023-03-22', '2023-03-29', 11900.00, 'Tamamlandı'),
(5, 34, 4, 4, '2024-10-17', '2024-10-24', 10850.00, 'Tamamlandı'),
(53, 11, 2, 2, '2023-02-10', '2023-02-20', 24000.00, 'Tamamlandı'),
(75, 96, 10, 10, '2020-02-25', '2020-03-09', 11875.00, 'Tamamlandı'),
(89, 12, 2, 2, '2023-05-10', '2023-05-16', 4200.00, 'Tamamlandı'),
(74, 90, 9, 9, '2024-01-09', '2024-01-22', 16900.00, 'Tamamlandı'),
(66, 93, 10, 10, '2021-11-12', '2021-11-13', 1250.00, 'Tamamlandı'),
(60, 6, 1, 1, '2023-03-05', '2023-03-13', 6000.00, 'Tamamlandı'),
(68, 54, 6, 6, '2023-09-06', '2023-09-08', 2200.00, 'Tamamlandı'),
(47, 7, 1, 1, '2020-04-28', '2020-05-04', 7500.00, 'Tamamlandı'),
(78, 94, 10, 10, '2024-02-04', '2024-02-13', 8550.00, 'Tamamlandı'),
(88, 84, 9, 9, '2021-08-11', '2021-08-16', 4500.00, 'Tamamlandı'),
(10, 98, 10, 10, '2020-03-15', '2020-03-24', 7200.00, 'Tamamlandı'),
(29, 29, 3, 3, '2021-10-30', '2021-11-06', 12600.00, 'Tamamlandı'),
(43, 71, 8, 8, '2024-09-17', '2024-09-22', 9500.00, 'Tamamlandı'),
(51, 82, 9, 9, '2022-01-05', '2022-01-14', 10800.00, 'Tamamlandı'),
(19, 85, 9, 9, '2020-03-13', '2020-03-22', 8100.00, 'Tamamlandı'),
(64, 5, 1, 1, '2020-11-25', '2020-12-08', 28600.00, 'Tamamlandı'),
(45, 94, 10, 10, '2020-10-28', '2020-11-07', 9500.00, 'Tamamlandı'),
(31, 81, 8, 8, '2024-06-11', '2024-06-16', 9500.00, 'Tamamlandı'),
(23, 95, 10, 10, '2023-05-03', '2023-05-08', 4750.00, 'Tamamlandı'),
(92, 69, 7, 7, '2024-01-25', '2024-01-29', 4200.00, 'Tamamlandı'),
(26, 73, 8, 8, '2020-01-27', '2020-02-02', 7800.00, 'Tamamlandı'),
(81, 33, 4, 4, '2022-01-30', '2022-02-03', 4800.00, 'Tamamlandı'),
(58, 52, 6, 6, '2022-05-23', '2022-05-30', 10500.00, 'Tamamlandı'),
(34, 80, 8, 8, '2020-09-09', '2020-09-23', 21700.00, 'Tamamlandı'),
(66, 62, 7, 7, '2023-04-14', '2023-04-21', 4900.00, 'Tamamlandı'),
(95, 14, 2, 2, '2023-08-31', '2023-09-05', 8000.00, 'Tamamlandı'),
(45, 44, 5, 5, '2024-09-26', '2024-10-08', 21600.00, 'Tamamlandı'),
(86, 43, 5, 5, '2024-03-01', '2024-03-04', 3300.00, 'Tamamlandı'),
(50, 86, 9, 9, '2021-02-02', '2021-02-13', 8800.00, 'Tamamlandı'),
(89, 24, 3, 3, '2022-03-07', '2022-03-10', 5100.00, 'Tamamlandı'),
(58, 24, 3, 3, '2022-05-06', '2022-05-18', 20400.00, 'Tamamlandı'),
(42, 86, 9, 9, '2020-11-09', '2020-11-22', 10400.00, 'Tamamlandı'),
(28, 63, 7, 7, '2020-04-18', '2020-04-27', 15300.00, 'Tamamlandı'),
(16, 4, 1, 1, '2023-01-21', '2023-01-30', 11250.00, 'Tamamlandı'),
(14, 77, 8, 8, '2023-08-17', '2023-08-31', 19500.00, 'Tamamlandı'),
(24, 46, 5, 5, '2021-12-21', '2021-12-26', 8250.00, 'Tamamlandı'),
(19, 13, 2, 2, '2022-06-18', '2022-06-21', 2700.00, 'Tamamlandı'),
(94, 32, 4, 4, '2020-08-29', '2020-08-30', 900.00, 'Tamamlandı'),
(92, 51, 6, 6, '2024-09-20', '2024-09-24', 6000.00, 'Tamamlandı'),
(66, 56, 6, 6, '2020-06-11', '2020-06-22', 9350.00, 'Tamamlandı'),
(31, 78, 8, 8, '2024-05-24', '2024-06-02', 13950.00, 'Tamamlandı'),
(26, 58, 6, 6, '2023-03-06', '2023-03-10', 4600.00, 'Tamamlandı'),
(31, 52, 6, 6, '2024-04-09', '2024-04-13', 6000.00, 'Tamamlandı'),
(31, 84, 9, 9, '2020-02-25', '2020-03-08', 10800.00, 'Tamamlandı'),
(47, 39, 4, 4, '2020-01-22', '2020-01-26', 4800.00, 'Tamamlandı'),
(39, 56, 6, 6, '2024-02-15', '2024-02-19', 3400.00, 'Tamamlandı'),
(15, 17, 2, 2, '2023-11-04', '2023-11-05', 750.00, 'Tamamlandı'),
(75, 21, 3, 3, '2021-01-27', '2021-02-07', 8250.00, 'Tamamlandı'),
(12, 58, 6, 6, '2024-03-18', '2024-03-24', 5100.00, 'Tamamlandı'),
(99, 52, 6, 6, '2020-01-24', '2020-01-31', 10500.00, 'Tamamlandı'),
(90, 30, 4, 4, '2022-10-14', '2022-10-24', 32000.00, 'Tamamlandı'),
(53, 41, 5, 5, '2024-06-02', '2024-06-05', 2700.00, 'Tamamlandı'),
(4, 64, 7, 7, '2022-09-28', '2022-10-05', 14000.00, 'Tamamlandı'),
-- Gelecek tarihli aktif rezervasyonlar (test için)
(1, 1, 1, 1, '2025-12-15', '2025-12-20', 5500.00, 'Onaylandı'),
(2, 2, 1, 2, '2025-12-18', '2025-12-25', 5950.00, 'Onaylandı'),
(3, 11, 2, 2, '2025-12-20', '2025-12-28', 19200.00, 'Beklemede'),
(5, 21, 3, 3, '2025-12-22', '2025-12-30', 6000.00, 'Beklemede'),
(6, 31, 4, 4, '2025-12-25', '2026-01-02', 11200.00, 'Onaylandı'),
(7, 41, 5, 5, '2026-01-05', '2026-01-10', 4500.00, 'Beklemede'),
(8, 51, 6, 6, '2026-01-08', '2026-01-15', 10500.00, 'Onaylandı'),
(10, 61, 7, 7, '2026-01-12', '2026-01-18', 9000.00, 'Beklemede');

-- ===================
-- 5. FATURALAR 
-- ===================
CREATE TABLE Faturalar (
  FaturaID INT AUTO_INCREMENT PRIMARY KEY,
  RezervasyonID INT UNIQUE,
  FaturaNo VARCHAR(20) UNIQUE,
  FaturaTarihi DATE,
  Tutar DECIMAL(10,2),
  KDV DECIMAL(10,2),
  OdemeYontemi VARCHAR(50),
  FOREIGN KEY (RezervasyonID) REFERENCES Rezervasyonlar(RezervasyonID)
);

-- Tamamlanmış rezervasyonlar için otomatik fatura oluşturma
INSERT INTO Faturalar (RezervasyonID, FaturaNo, FaturaTarihi, Tutar, KDV, OdemeYontemi)
SELECT 
    r.RezervasyonID,
    CONCAT('F', LPAD(r.RezervasyonID, 5, '0')),
    r.TeslimTarihi,
    r.ToplamUcret,
    ROUND(r.ToplamUcret * 0.20, 2),
    CASE 
        WHEN r.RezervasyonID % 3 = 0 THEN 'Nakit'
        WHEN r.RezervasyonID % 3 = 1 THEN 'Kredi Kartı'
        ELSE 'Havale/EFT'
    END
FROM Rezervasyonlar r
WHERE r.Durum = 'Tamamlandı';

-- ===================
-- 6. TRIGGER'LAR
-- ===================

DELIMITER //

-- Çakışan Rezervasyon Engelleme
CREATE TRIGGER Engel_CakisanRezervasyon
BEFORE INSERT ON Rezervasyonlar
FOR EACH ROW
BEGIN
    DECLARE cakisma_sayisi INT DEFAULT 0;

    SELECT COUNT(*) INTO cakisma_sayisi
    FROM Rezervasyonlar
    WHERE AracID = NEW.AracID
      AND Durum IN ('Onaylandı', 'Devam Ediyor', 'Beklemede')
      AND (
          (AlisTarihi BETWEEN NEW.AlisTarihi AND NEW.TeslimTarihi) OR 
          (TeslimTarihi BETWEEN NEW.AlisTarihi AND NEW.TeslimTarihi) OR
          (AlisTarihi < NEW.AlisTarihi AND TeslimTarihi > NEW.TeslimTarihi)
      );

    IF cakisma_sayisi > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'HATA: Seçilen tarihlerde bu araç zaten rezerve edilmiştir!';
    END IF;
END //

DELIMITER ;

DELIMITER //

-- Bakımdaki Araç Rezervasyon Engelleme
CREATE TRIGGER Engel_BakimdakiArac
BEFORE INSERT ON Rezervasyonlar
FOR EACH ROW
BEGIN
    DECLARE arac_durumu VARCHAR(20);
    
    SELECT Durum INTO arac_durumu FROM Araclar WHERE AracID = NEW.AracID;
    
    IF arac_durumu = 'Bakımda' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'HATA: Bakımda olan bir araca rezervasyon yapılamaz!';
    END IF;
END //

DELIMITER ;

DELIMITER //

-- Tamamlandığında Araç Konumu Güncelleme
CREATE TRIGGER Guncelle_AracKonumu_Teslimde
AFTER UPDATE ON Rezervasyonlar
FOR EACH ROW
BEGIN
    IF NEW.Durum = 'Tamamlandı' AND OLD.Durum != 'Tamamlandı' THEN
        UPDATE Araclar 
        SET MevcutOfisID = NEW.TeslimOfisID,
            Durum = 'Müsait'
        WHERE AracID = NEW.AracID;
    END IF;
END //

DELIMITER ;

-- ===================
-- 7. VERİ KONTROLÜ
-- ===================

-- Tablo bazlı kayıt sayıları
SELECT 'Kullanicilar' AS Tablo, COUNT(*) AS Kayit FROM Kullanicilar
UNION ALL SELECT 'Ofisler', COUNT(*) FROM Ofisler
UNION ALL SELECT 'Araclar', COUNT(*) FROM Araclar
UNION ALL SELECT 'Rezervasyonlar', COUNT(*) FROM Rezervasyonlar
UNION ALL SELECT 'Faturalar', COUNT(*) FROM Faturalar;

-- Araç durumları
SELECT Durum, COUNT(*) AS Adet FROM Araclar GROUP BY Durum;

-- Rezervasyon durumları
SELECT Durum, COUNT(*) AS Adet FROM Rezervasyonlar GROUP BY Durum;

-- Ofis bazlı araç dağılımı
SELECT o.OfisAdi, o.Sehir, COUNT(a.AracID) AS AracSayisi
FROM Ofisler o
LEFT JOIN Araclar a ON o.OfisID = a.MevcutOfisID
GROUP BY o.OfisID, o.OfisAdi, o.Sehir;

-- ===================
-- GİRİŞ BİLGİLERİ
-- ===================
-- 
-- KULLANICI GİRİŞİ:
-- E-posta: ahmet.yilmaz01@gmail.com
-- Şifre: 123456
--
-- OFİS GİRİŞİ:
-- E-posta: ankara@rentdrive.com
-- Şifre: 123456
--
