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
('Ahmet','Yılmaz','ahmet.yilmaz01@gmail.com','sha256_ahmet01_fakehash','0551 234 56 70','EHLAD048','2020-01-12 14:27:33'),
('Elif','Kara','elif.kara02@hotmail.com','sha256_elif02_fakehash','0551 903 21 84','EHLAH428','2020-02-05 10:42:11'),
('Berke','Demir','berke.demir03@gmail.com','sha256_berke03_fakehash','0552 678 14 39','EHLAI631','2020-03-18 19:03:58'),
('Zeynep','Aydın','zeynep.aydin04@hotmail.com','sha256_zeynep04_fakehash','0553 742 90 12','EHLAM454','2020-04-09 16:54:21'),
('Mert','Can','mert.can05@gmail.com','sha256_mert05_fakehash','0554 398 27 61','EHLAR505','2020-05-14 11:39:45'),
('Ece','Yıldız','ece.yildiz06@hotmail.com','sha256_ece06_fakehash','0555 810 43 29','EHLAS015','2020-06-27 09:16:50'),
('Emre','Kurt','emre.kurt07@gmail.com','sha256_emre07_fakehash','0552 506 45 37','EHLAT536','2020-07-11 23:08:14'),
('Ayşe','Yalçın','ayse.yalcin08@hotmail.com','sha256_ayse08_fakehash','0550 527 38 15','EHLBR923','2020-08-03 20:57:09'),
('Onur','Koçak','onur.kocak09@gmail.com','sha256_onur09_fakehash','0553 899 18 03','EHLBU652','2020-09-22 12:45:32'),
('Derya','Polat','derya.polat10@hotmail.com','sha256_derya10_fakehash','0551 557 99 48','EHLBV013','2020-10-05 18:14:55'),
('Ali','Şahin','ali.sahin11@gmail.com','sha256_ali11_fakehash','0554 574 56 63','EHLBW658','2021-01-14 13:22:09'),
('Melisa','Koç','melisa.koc12@hotmail.com','sha256_melisa12_fakehash','0555 787 61 00','EHLCF992','2021-02-03 09:50:43'),
('Baran','Yüce','baran.yuce13@gmail.com','sha256_baran13_fakehash','0552 788 46 70','EHLCG387','2021-02-19 15:34:22'),
('İrem','Arslan','irem.arslan14@hotmail.com','sha256_irem14_fakehash','0550 656 56 11','EHLCN439','2021-03-11 17:12:57'),
('Furkan','Şen','furkan.sen15@gmail.com','sha256_furkan15_fakehash','0551 449 98 79','EHLDK330','2021-03-28 22:31:18'),
('Ceren','Kaya','ceren.kaya16@hotmail.com','sha256_ceren16_fakehash','0553 290 60 55','EHLDM090','2021-04-09 09:45:02'),
('Hakan','Aksoy','hakan.aksoy17@gmail.com','sha256_hakan17_fakehash','0554 700 11 24','EHLEC312','2021-04-27 21:08:44'),
('Nazlı','Demir','nazli.demir18@hotmail.com','sha256_nazli18_fakehash','0550 315 74 92','EHLEL196','2021-05-12 19:23:13'),
('Yusuf','Yalın','yusuf.yalin19@gmail.com','sha256_yusuf19_fakehash','0552 982 03 61','EHLFA871','2021-05-29 14:14:07'),
('Can','Özkan','can.ozkan20@hotmail.com','sha256_can20_fakehash','0553 411 39 27','EHLFK209','2021-06-07 11:49:36'),
('Selin','Er','selin.er21@gmail.com','sha256_selin21_fakehash','0554 263 88 40','EHLFM774','2021-06-29 16:33:58'),
('Deniz','Bulut','deniz.bulut22@hotmail.com','sha256_deniz22_fakehash','0551 744 22 19','EHLGB813','2021-07-18 21:17:00'),
('Kaan','Bozkurt','kaan.bozkurt23@gmail.com','sha256_kaan23_fakehash','0555 093 45 88','EHLGH069','2021-08-05 10:26:40'),
('Burcu','Taş','burcu.tas24@hotmail.com','sha256_burcu24_fakehash','0553 204 18 74','EHLGS247','2021-08-25 09:58:22'),
('Musa','Güneş','musa.gunes25@gmail.com','sha256_musa25_fakehash','0550 851 67 30','EHLGX901','2021-09-09 18:05:11'),
('Gizem','Çelik','gizem.celik26@hotmail.com','sha256_gizem26_fakehash','0554 627 44 19','EHLHA223','2021-09-27 11:17:42'),
('Tuna','Ergin','tuna.ergin27@gmail.com','sha256_tuna27_fakehash','0552 714 95 02','EHLHB799','2021-10-04 20:52:37'),
('Bora','Kılınç','bora.kilinc28@hotmail.com','sha256_bora28_fakehash','0551 306 82 41','EHLHC612','2021-10-22 14:09:01'),
('Eylül','Yaman','eylul.yaman29@gmail.com','sha256_eylul29_fakehash','0554 998 53 77','EHLHM380','2021-11-03 15:33:22'),
('Hilal','Sağlam','hilal.saglam30@hotmail.com','sha256_hilal30_fakehash','0553 120 45 63','EHLHZ956','2021-11-28 18:44:10'),
('Kübra','Aslan','kubra.aslan31@gmail.com','sha256_kubra31_fakehash','0550 930 08 31','EHLID081','2022-01-07 12:05:48'),
('Serkan','Uzun','serkan.uzun32@hotmail.com','sha256_serkan32_fakehash','0551 486 59 40','EHLIV277','2022-01-22 19:24:55'),
('Yağmur','Sevgi','yagmur.sevgi33@gmail.com','sha256_yagmur33_fakehash','0552 719 34 68','EHLJA144','2022-02-04 16:41:03'),
('Talha','Özdemir','talha.ozdemir34@hotmail.com','sha256_talha34_fakehash','0555 421 07 92','EHLJF640','2022-02-26 21:52:38'),
('Damla','Gür','damla.gur35@gmail.com','sha256_damla35_fakehash','0551 665 33 47','EHLJG221','2022-03-10 10:36:55'),
('Burak','Öztürk','burak.ozturk36@hotmail.com','sha256_burak36_fakehash','0554 237 92 10','EHLJT330','2022-03-28 22:39:42'),
('Merve','Altun','merve.altun37@gmail.com','sha256_merve37_fakehash','0553 792 16 85','EHLLA703','2022-04-06 08:59:13'),
('Arda','Işık','arda.isik38@hotmail.com','sha256_arda38_fakehash','0550 504 90 13','EHLLB520','2022-04-21 11:24:56'),
('Sena','Ateş','sena.ates39@gmail.com','sha256_sena39_fakehash','0551 988 44 72','EHLLE404','2022-05-12 15:42:18'),
('Eren','Özer','eren.ozer40@hotmail.com','sha256_eren40_fakehash','0552 361 08 97','EHLLM238','2022-06-01 09:58:44'),
('Yaren','Turan','yaren.turan41@gmail.com','sha256_yaren41_fakehash','0555 154 22 06','EHLLX187','2022-06-29 17:22:01'),
('Hasan','Durmaz','hasan.durmaz42@hotmail.com','sha256_hasan42_fakehash','0553 842 67 51','EHLLZ301','2022-07-16 20:44:12'),
('Neşe','Torun','nese.torun43@gmail.com','sha256_nese43_fakehash','0551 409 13 86','EHLMF420','2022-07-27 14:19:03'),
('Okan','Boz','okan.boz44@hotmail.com','sha256_okan44_fakehash','0550 272 40 19','EHLMK732','2022-08-15 11:57:50'),
('Dilara','Varol','dilara.varol45@gmail.com','sha256_dilara45_fakehash','0552 764 99 04','EHLMN055','2022-08-29 16:49:28'),
('Batuhan','Eker','batuhan.eker46@hotmail.com','sha256_batuhan46_fakehash','0554 903 70 82','EHLMR880','2022-09-10 13:32:44'),
('Ufuk','Tetik','ufuk.tetik47@gmail.com','sha256_ufuk47_fakehash','0555 319 48 25','EHLMZ114','2022-09-26 21:58:08'),
('Betül','Acar','betul.acar48@hotmail.com','sha256_betul48_fakehash','0553 607 22 94','EHLNA541','2022-10-07 18:07:12'),
('Taner','Gök','taner.gok49@gmail.com','sha256_taner49_fakehash','0551 874 05 38','EHLNJ031','2022-10-23 10:29:37'),
('Nisanur','Keleş','nisanur.keles50@hotmail.com','sha256_nisanur50_fakehash','0550 638 17 66','EHLNK288','2022-11-12 20:40:52'),
('Kerem','Tan','kerem.tan51@gmail.com','sha256_kerem51_fakehash','0552 725 34 10','EHLNN904','2023-01-04 14:28:44'),
('Beyza','Kalkan','beyza.kalkan52@hotmail.com','sha256_beyza52_fakehash','0554 519 76 02','EHLNP667','2023-01-18 17:15:29'),
('Tolga','Bilgin','tolga.bilgin53@gmail.com','sha256_tolga53_fakehash','0555 280 45 91','EHLNZ406','2023-02-07 20:59:46'),
('Zehra','Kurt','zehra.kurt54@hotmail.com','sha256_zehra54_fakehash','0553 153 99 28','EHLPB019','2023-02-24 15:41:18'),
('Sinan','Güler','sinan.guler55@gmail.com','sha256_sinan55_fakehash','0551 736 10 84','EHLPJ292','2023-03-09 11:32:55'),
('Pelinsu','Ersoy','pelinsu.ersoy56@hotmail.com','sha256_pelinsu56_fakehash','0550 492 37 15','EHLPK507','2023-03-28 19:44:22'),
('Said','Kavak','said.kavak57@gmail.com','sha256_said57_fakehash','0552 920 54 08','EHLPQ887','2023-04-03 09:58:11'),
('Tuğba','Uçar','tugba.ucar58@hotmail.com','sha256_tugba58_fakehash','0554 648 75 39','EHLPX002','2023-04-25 21:22:42'),
('Yiğit','Tuna','yigit.tuna59@gmail.com','sha256_yigit59_fakehash','0555 507 66 41','EHLQA773','2023-05-06 10:15:13'),
('Şule','Irlı','sule.irl60@hotmail.com','sha256_sule60_fakehash','0553 220 97 06','EHLQB622','2023-05-29 16:42:19'),
('Oğuz','Gören','oguz.goren61@gmail.com','sha256_oguz61_fakehash','0551 945 33 18','EHLQE204','2023-06-14 21:58:02'),
('Aslı','Koral','asli.koral62@hotmail.com','sha256_asli62_fakehash','0550 713 05 49','EHLQH772','2023-06-27 14:33:44'),
('Berkay','Şimşek','berkay.simsek63@gmail.com','sha256_berkay63_fakehash','0552 801 94 20','EHLQM441','2023-07-08 11:49:08'),
('Elçin','Gürler','elcin.gurler64@hotmail.com','sha256_elcin64_fakehash','0554 988 50 37','EHLQS553','2023-07-22 18:28:51'),
('Ayhan','Soylu','ayhan.soylu65@gmail.com','sha256_ayhan65_fakehash','0555 379 84 92','EHLQV118','2023-08-05 20:49:37'),
('Mina','Gökçe','mina.gokce66@hotmail.com','sha256_mina66_fakehash','0553 146 22 58','EHLRA365','2023-08-21 12:41:12'),
('Yunus','Akyol','yunus.akyol67@gmail.com','sha256_yunus67_fakehash','0551 624 79 01','EHLRD902','2023-09-03 09:33:52'),
('Dilan','Ertem','dilan.ertem68@hotmail.com','sha256_dilan68_fakehash','0550 503 48 36','EHLRH113','2023-09-27 14:16:07'),
('Göktuğ','Çınar','goktug.cinar69@gmail.com','sha256_goktug69_fakehash','0552 997 11 75','EHLRM784','2023-10-12 19:25:31'),
('Sibel','Yetkin','sibel.yetkin70@hotmail.com','sha256_sibel70_fakehash','0554 764 39 04','EHLRX211','2023-10-29 21:57:03'),
('Harun','Erbay','harun.erbay71@gmail.com','sha256_harun71_fakehash','0555 645 20 88','EHLRY877','2024-01-08 13:41:40'),
('Nursel','Kaynar','nursel.kaynar72@hotmail.com','sha256_nursel72_fakehash','0553 129 47 30','EHLSB038','2024-01-25 09:58:50'),
('Bahtiyar','Ölmez','bahtiyar.olmez73@gmail.com','sha256_bahtiyar73_fakehash','0551 706 83 95','EHLSD496','2024-02-10 16:33:29'),
('Mehmet','Tutku','mehmet.tutku74@hotmail.com','sha256_mehmet74_fakehash','0550 854 62 17','EHLSF739','2024-02-27 22:47:53'),
('Gül','Solmaz','gul.solmaz75@gmail.com','sha256_gul75_fakehash','0552 412 30 69','EHLSJ209','2024-03-09 14:25:41'),
('Kemal','Zengin','kemal.zengin76@hotmail.com','sha256_kemal76_fakehash','0554 698 04 21','EHLSP992','2024-03-25 11:30:57'),
('Fatoş','Kar','fatos.kar77@gmail.com','sha256_fatos77_fakehash','0555 587 93 46','EHLSS355','2024-04-12 19:58:16'),
('Burhan','Erinç','burhan.erinc78@hotmail.com','sha256_burhan78_fakehash','0553 270 18 52','EHLST644','2024-04-27 17:43:29'),
('Seçil','Ateş','secil.ates79@gmail.com','sha256_secil79_fakehash','0551 935 71 08','EHLTA507','2024-05-18 10:55:13'),
('Volkan','Ertem','volkan.ertem80@hotmail.com','sha256_volkan80_fakehash','0550 603 25 90','EHLTD883','2024-06-01 21:31:40'),
('Nehir','Var','nehir.var81@gmail.com','sha256_nehir81_fakehash','0552 891 40 37','EHLTK221','2024-06-27 12:47:51'),
('Aydın','Bozan','aydin.bozan82@hotmail.com','sha256_aydin82_fakehash','0554 305 69 14','EHLTP608','2024-07-11 15:39:33'),
('Eylül','Ören','eylul.oren83@gmail.com','sha256_eylul83_fakehash','0555 718 92 46','EHLTX947','2024-07-29 10:13:50'),
('Hülya','Ege','hulya.ege84@hotmail.com','sha256_hulya84_fakehash','0553 461 57 20','EHLUA302','2024-08-13 19:54:17'),
('Rıza','Kaplan','riza.kaplan85@gmail.com','sha256_riza85_fakehash','0551 826 03 79','EHLUC699','2024-09-02 11:29:48'),
('Sude','Kal','sude.kal86@hotmail.com','sha256_sude86_fakehash','0554 595 40 43','EHLXW518','2024-09-27 20:08:01'),
('Efe','Güçlü','efe.guclu87@gmail.com','sha256_efe87_fakehash','0550 728 03 72','EHLXY662','2024-10-11 18:55:22'),
('Mehtap','Ersin','mehtap.ersin88@hotmail.com','sha256_mehtap88_fakehash','0553 738 70 24','EHLYA677','2024-10-28 22:19:37'),
('Alper','Kalkan','alper.kalkan89@gmail.com','sha256_alper89_fakehash','0551 165 30 40','EHLYC035','2024-11-09 11:45:19'),
('Nur','Güray','nur.guray90@hotmail.com','sha256_nur90_fakehash','0555 845 18 89','EHLYE848','2024-11-26 13:50:53'),
('Halil','Tanju','halil.tanju91@gmail.com','sha256_halil91_fakehash','0552 439 60 81','EHLYG501','2025-01-03 15:24:11'),
('Murat','Eren','murat.eren92@hotmail.com','sha256_murat92_fakehash','0554 813 38 60','EHLYJ153','2025-01-21 11:33:40'),
('İlayda','Soylu','ilayda.soylu93@gmail.com','sha256_ilayda93_fakehash','0555 078 12 34','EHLYJ909','2025-02-07 12:49:26'),
('Çağrı','Durak','cagri.durak94@hotmail.com','sha256_cagri94_fakehash','0553 705 98 97','EHLYM152','2025-02-27 18:35:59'),
('Pınar','Yalçın','pinar.yalcin95@gmail.com','sha256_pinar95_fakehash','0551 375 57 19','EHLYZ638','2025-03-11 19:28:14'),
('Hüseyin','Göl','huseyin.gol96@hotmail.com','sha256_huseyin96_fakehash','0550 509 71 48','EHLZK920','2025-03-29 10:09:07'),
('Aysun','Keleş','aysun.keles97@gmail.com','sha256_aysun97_fakehash','0554 555 86 67','EHLZN896','2025-04-12 22:58:32'),
('Tolunay','Sağ','tolunay.sag98@hotmail.com','sha256_tolunay98_fakehash','0552 738 12 88','EHLZO500','2025-04-26 08:57:55'),
('Esra','İlhan','esra.ilhan99@gmail.com','sha256_esra99_fakehash','0555 983 55 54','EHLZS368','2025-05-07 16:41:20'),
('Korel','Bilen','korel.bilen100@hotmail.com','sha256_korel100_fakehash','0559 872 02 15','EHLZX523','2025-05-26 14:19:44');



SELECT * FROM Kullanicilar

CREATE TABLE Ofisler (
  OfisID INT AUTO_INCREMENT PRIMARY KEY,
  OfisAdi VARCHAR(100),
  Sehir VARCHAR(50),
  Adres TEXT,
  Telefon VARCHAR(15)
);

INSERT INTO Ofisler (OfisAdi, Sehir, Adres, Telefon) VALUES
('Ankara Merkez Ofis', 'Ankara', 'Çankaya, Atatürk Bulvarı No:45 Kavaklıdere', '0312 450 12 34'),
('İstanbul Avrupa Ofisi', 'İstanbul', 'Beşiktaş, Barbaros Bulvarı No:22', '0212 340 98 76'),
('İstanbul Anadolu Ofisi', 'İstanbul', 'Kadıköy, Bağdat Caddesi No:180', '0216 555 44 33'),
('İzmir Konak Ofisi', 'İzmir', 'Konak, Kordonboyu Mah. Sahil Cd. No:12', '0232 410 22 11'),
('Antalya Lara Ofisi', 'Antalya', 'Lara, Güzeloba Mah. Özgürlük Cd. No:78', '0242 330 44 28'),
('Bursa Nilüfer Ofisi', 'Bursa', 'Nilüfer, FSM Bulvarı No:55', '0224 360 77 55'),
('Adana Seyhan Ofisi', 'Adana', 'Seyhan, Atatürk Cd. No:99', '0322 420 33 00'),
('Trabzon Meydan Ofisi', 'Trabzon', 'Ortahisar, Meydan Cd. No:8', '0462 321 45 65'),
('Gaziantep Şehitkamil Ofisi', 'Gaziantep', 'Şehitkamil, İnönü Cd. No:67', '0342 550 81 33'),
('Eskişehir Tepebaşı Ofisi', 'Eskişehir', 'Tepebaşı, İsmet İnönü Cd. No:14', '0222 340 56 42');


SELECT * FROM Ofisler



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
('06 ANK 101', 'Toyota',      'Corolla',      2020, 'Otomatik', 'Benzin',   1100.00, 1, 'Müsait'),
('06 ANK 102', 'Renault',     'Clio',         2019, 'Manuel',   'Benzin',    850.00, 1, 'Müsait'),
('06 ANK 103', 'Volkswagen',  'Golf',         2021, 'Otomatik', 'Dizel',    1400.00, 1, 'Kirada'),
('06 ANK 104', 'Hyundai',     'i20',          2022, 'Otomatik', 'Hibrit',   1250.00, 1, 'Bakımda'),
('06 ANK 105', 'BMW',         '320i',         2020, 'Otomatik', 'Benzin',   2200.00, 1, 'Müsait'),
('06 ANK 106', 'Fiat',        'Egea',         2018, 'Manuel',   'Dizel',     750.00, 1, 'Müsait'),
('06 ANK 107', 'Skoda',       'Octavia',      2019, 'Otomatik', 'Dizel',    1250.00, 1, 'Müsait'),
('06 ANK 108', 'Honda',       'Civic',        2021, 'Otomatik', 'Benzin',   1350.00, 1, 'Kirada'),
('06 ANK 109', 'Dacia',       'Duster',       2018, 'Manuel',   'Dizel',     900.00, 1, 'Müsait'),
('06 ANK 110', 'Tesla',       'Model 3',      2023, 'Otomatik', 'Elektrik', 2900.00, 1, 'Müsait'),
('34 AVP 201', 'Mercedes',    'C200',         2021, 'Otomatik', 'Benzin',   2400.00, 2, 'Müsait'),
('34 AVP 202', 'Fiat',        'Egea',         2017, 'Manuel',   'Benzin',    700.00, 2, 'Müsait'),
('34 AVP 203', 'Opel',        'Astra',        2019, 'Manuel',   'Benzin',    900.00, 2, 'Kirada'),
('34 AVP 204', 'Peugeot',     '3008',         2021, 'Otomatik', 'Dizel',    1600.00, 2, 'Müsait'),
('34 AVP 205', 'Tesla',       'Model Y',      2024, 'Otomatik', 'Elektrik', 3100.00, 2, 'Bakımda'),
('34 AVP 206', 'Volkswagen',  'Passat',       2020, 'Otomatik', 'Dizel',    1700.00, 2, 'Müsait'),
('34 AVP 207', 'Toyota',      'Yaris',        2018, 'Manuel',   'Benzin',    750.00, 2, 'Müsait'),
('34 AVP 208', 'BMW',         '520d',         2020, 'Otomatik', 'Dizel',    2600.00, 2, 'Kirada'),
('34 AVP 209', 'Hyundai',     'Elantra',      2021, 'Otomatik', 'Benzin',   1200.00, 2, 'Müsait'),
('34 AVP 210', 'Renault',     'Megane',       2019, 'Otomatik', 'Dizel',    1350.00, 2, 'Müsait'),
('34 AND 301', 'Toyota',      'Auris',        2017, 'Manuel',   'Benzin',    750.00, 3, 'Müsait'),
('34 AND 302', 'Honda',       'Civic',        2020, 'Otomatik', 'Benzin',   1300.00, 3, 'Müsait'),
('34 AND 303', 'Skoda',       'Octavia',      2019, 'Otomatik', 'Dizel',    1250.00, 3, 'Kirada'),
('34 AND 304', 'Nissan',      'Qashqai',      2022, 'Otomatik', 'Benzin',   1700.00, 3, 'Müsait'),
('34 AND 305', 'Volkswagen',  'Passat',       2021, 'Otomatik', 'Dizel',    1600.00, 3, 'Bakımda'),
('34 AND 306', 'Fiat',        'Panda',        2016, 'Manuel',   'Benzin',    650.00, 3, 'Müsait'),
('34 AND 307', 'Dacia',       'Sandero',      2018, 'Manuel',   'Benzin',    700.00, 3, 'Müsait'),
('34 AND 308', 'Peugeot',     '208',          2019, 'Manuel',   'Benzin',    800.00, 3, 'Kirada'),
('34 AND 309', 'BMW',         '118i',         2019, 'Otomatik', 'Benzin',   1800.00, 3, 'Müsait'),
('34 AND 310', 'Tesla',       'Model S',      2023, 'Otomatik', 'Elektrik', 3200.00, 3, 'Müsait'),
('35 IZM 401', 'Renault',     'Megane',       2020, 'Otomatik', 'Dizel',    1400.00, 4, 'Müsait'),
('35 IZM 402', 'Toyota',      'Corolla',      2018, 'Manuel',   'Benzin',    900.00, 4, 'Müsait'),
('35 IZM 403', 'Hyundai',     'Elantra',      2021, 'Otomatik', 'Benzin',   1200.00, 4, 'Kirada'),
('35 IZM 404', 'Peugeot',     '3008',         2020, 'Otomatik', 'Dizel',    1550.00, 4, 'Müsait'),
('35 IZM 405', 'BMW',         'X1',           2020, 'Otomatik', 'Dizel',    2100.00, 4, 'Bakımda'),
('35 IZM 406', 'Volkswagen',  'Golf',         2019, 'Manuel',   'Benzin',   1000.00, 4, 'Müsait'),
('35 IZM 407', 'Fiat',        'Egea',         2017, 'Manuel',   'Dizel',     750.00, 4, 'Müsait'),
('35 IZM 408', 'Honda',       'Jazz',         2018, 'Manuel',   'Benzin',    800.00, 4, 'Kirada'),
('35 IZM 409', 'Mercedes',    'A180',         2021, 'Otomatik', 'Benzin',   2000.00, 4, 'Müsait'),
('35 IZM 410', 'Tesla',       'Model 3',      2022, 'Otomatik', 'Elektrik', 2850.00, 4, 'Müsait'),
('07 ANT 501', 'Dacia',       'Duster',       2019, 'Manuel',   'Dizel',     900.00, 5, 'Müsait'),
('07 ANT 502', 'Hyundai',     'Tucson',       2022, 'Otomatik', 'Benzin',   1800.00, 5, 'Kirada'),
('07 ANT 503', 'Renault',     'Captur',       2020, 'Otomatik', 'Benzin',   1100.00, 5, 'Müsait'),
('07 ANT 504', 'Toyota',      'CH-R',         2021, 'Otomatik', 'Hibrit',   1600.00, 5, 'Müsait'),
('07 ANT 505', 'Volkswagen',  'T-Roc',        2022, 'Otomatik', 'Benzin',   1750.00, 5, 'Bakımda'),
('07 ANT 506', 'Fiat',        'Egea',         2018, 'Manuel',   'Dizel',     750.00, 5, 'Müsait'),
('07 ANT 507', 'Skoda',       'Karoq',        2021, 'Otomatik', 'Dizel',    1650.00, 5, 'Müsait'),
('07 ANT 508', 'Peugeot',     '2008',         2020, 'Otomatik', 'Dizel',    1400.00, 5, 'Kirada'),
('07 ANT 509', 'Honda',       'CR-V',         2021, 'Otomatik', 'Benzin',   1900.00, 5, 'Müsait'),
('07 ANT 510', 'BMW',         'X3',           2022, 'Otomatik', 'Dizel',    2500.00, 5, 'Müsait'),
('16 BRS 601', 'Fiat',        'Panda',        2016, 'Manuel',   'Benzin',    650.00, 6, 'Müsait'),
('16 BRS 602', 'Skoda',       'Superb',       2020, 'Otomatik', 'Dizel',    1500.00, 6, 'Müsait'),
('16 BRS 603', 'Honda',       'Jazz',         2018, 'Manuel',   'Benzin',    800.00, 6, 'Kirada'),
('16 BRS 604', 'Hyundai',     'i30',          2020, 'Otomatik', 'Benzin',   1100.00, 6, 'Müsait'),
('16 BRS 605', 'Tesla',       'Model Y',      2024, 'Otomatik', 'Elektrik', 3000.00, 6, 'Bakımda'),
('16 BRS 606', 'Volkswagen',  'Golf',         2019, 'Manuel',   'Benzin',   1000.00, 6, 'Müsait'),
('16 BRS 607', 'Renault',     'Fluence',      2017, 'Manuel',   'Dizel',     850.00, 6, 'Müsait'),
('16 BRS 608', 'Toyota',      'Corolla',      2018, 'Otomatik', 'Benzin',   1150.00, 6, 'Kirada'),
('16 BRS 609', 'Mercedes',    'CLA 180',      2020, 'Otomatik', 'Benzin',   2300.00, 6, 'Müsait'),
('16 BRS 610', 'BMW',         '320d',         2021, 'Otomatik', 'Dizel',    2400.00, 6, 'Müsait'),
('01 ADN 701', 'Renault',     'Talisman',     2019, 'Otomatik', 'Dizel',    1500.00, 7, 'Müsait'),
('01 ADN 702', 'Fiat',        'Linea',        2018, 'Manuel',   'Benzin',    700.00, 7, 'Müsait'),
('01 ADN 703', 'Peugeot',     '508',          2020, 'Otomatik', 'Dizel',    1700.00, 7, 'Kirada'),
('01 ADN 704', 'Toyota',      'Camry',        2021, 'Otomatik', 'Benzin',   2000.00, 7, 'Bakımda'),
('01 ADN 705', 'Hyundai',     'Kona',         2022, 'Otomatik', 'Elektrik', 2300.00, 7, 'Müsait'),
('01 ADN 706', 'Volkswagen',  'Jetta',        2017, 'Manuel',   'Benzin',    900.00, 7, 'Müsait'),
('01 ADN 707', 'Dacia',       'Logan',        2016, 'Manuel',   'Benzin',    650.00, 7, 'Müsait'),
('01 ADN 708', 'Opel',        'Corsa',        2018, 'Manuel',   'Benzin',    750.00, 7, 'Kirada'),
('01 ADN 709', 'Honda',       'City',         2019, 'Otomatik', 'Benzin',   1050.00, 7, 'Müsait'),
('01 ADN 710', 'Mercedes',    'GLA 200',      2022, 'Otomatik', 'Benzin',   2500.00, 7, 'Müsait'),
('61 TRB 801', 'Volkswagen',  'Tiguan',       2021, 'Otomatik', 'Dizel',    1900.00, 8, 'Müsait'),
('61 TRB 802', 'Toyota',      'RAV4',         2020, 'Otomatik', 'Hibrit',   2100.00, 8, 'Kirada'),
('61 TRB 803', 'Honda',       'HR-V',         2019, 'Otomatik', 'Benzin',   1300.00, 8, 'Müsait'),
('61 TRB 804', 'Dacia',       'Sandero',      2018, 'Manuel',   'Benzin',    750.00, 8, 'Müsait'),
('61 TRB 805', 'BMW',         'X3',           2022, 'Otomatik', 'Dizel',    2500.00, 8, 'Bakımda'),
('61 TRB 806', 'Renault',     'Kadjar',       2019, 'Otomatik', 'Benzin',   1300.00, 8, 'Müsait'),
('61 TRB 807', 'Hyundai',     'Bayon',        2021, 'Otomatik', 'Benzin',   1200.00, 8, 'Müsait'),
('61 TRB 808', 'Peugeot',     '3008',         2020, 'Otomatik', 'Dizel',    1550.00, 8, 'Kirada'),
('61 TRB 809', 'Fiat',        'Egea',         2018, 'Manuel',   'Dizel',     750.00, 8, 'Müsait'),
('61 TRB 810', 'Tesla',       'Model 3',      2023, 'Otomatik', 'Elektrik', 2900.00, 8, 'Müsait'),
('27 GZT 901', 'Renault',     'Clio',         2019, 'Manuel',   'Benzin',    850.00, 9, 'Müsait'),
('27 GZT 902', 'Hyundai',     'Elantra',      2021, 'Otomatik', 'Benzin',   1200.00, 9, 'Kirada'),
('27 GZT 903', 'Peugeot',     '2008',         2022, 'Otomatik', 'Dizel',    1400.00, 9, 'Müsait'),
('27 GZT 904', 'Toyota',      'Corolla',      2020, 'Manuel',   'Benzin',    950.00, 9, 'Müsait'),
('27 GZT 905', 'Volkswagen',  'Golf',         2021, 'Otomatik', 'Dizel',    1500.00, 9, 'Bakımda'),
('27 GZT 906', 'Fiat',        'Tipo',         2018, 'Manuel',   'Dizel',     800.00, 9, 'Müsait'),
('27 GZT 907', 'Opel',        'Insignia',     2019, 'Otomatik', 'Dizel',    1600.00, 9, 'Müsait'),
('27 GZT 908', 'Dacia',       'Duster',       2018, 'Manuel',   'Dizel',     900.00, 9, 'Kirada'),
('27 GZT 909', 'Honda',       'Civic',        2020, 'Otomatik', 'Benzin',   1300.00, 9, 'Müsait'),
('27 GZT 910', 'BMW',         '320i',         2021, 'Otomatik', 'Benzin',   2200.00, 9, 'Müsait'),
('26 ESK 001', 'Fiat',        'Egea',         2018, 'Manuel',   'Dizel',     750.00, 10, 'Müsait'),
('26 ESK 002', 'Toyota',      'Auris',        2017, 'Manuel',   'Benzin',    700.00, 10, 'Müsait'),
('26 ESK 003', 'Hyundai',     'i20',          2022, 'Otomatik', 'Hibrit',   1250.00, 10, 'Kirada'),
('26 ESK 004', 'BMW',         '118i',         2019, 'Otomatik', 'Benzin',   1800.00, 10, 'Müsait'),
('26 ESK 005', 'Tesla',       'Model S',      2023, 'Otomatik', 'Elektrik', 3200.00, 10, 'Bakımda'),
('26 ESK 006', 'Renault',     'Megane',       2019, 'Otomatik', 'Dizel',    1400.00, 10, 'Müsait'),
('26 ESK 007', 'Volkswagen',  'Golf',         2018, 'Manuel',   'Benzin',   950.00, 10, 'Müsait'),
('26 ESK 008', 'Opel',        'Astra',        2018, 'Manuel',   'Benzin',    900.00, 10, 'Kirada'),
('26 ESK 009', 'Peugeot',     '301',          2017, 'Manuel',   'Dizel',     800.00, 10, 'Müsait'),
('26 ESK 010', 'Mercedes',    'C180',         2020, 'Otomatik', 'Benzin',   2300.00, 10, 'Müsait');


SELECT * FROM Araclar

CREATE TABLE Rezervasyonlar (
  RezervasyonID INT AUTO_INCREMENT PRIMARY KEY,
  KullaniciID INT,
  AracID INT,
  AlisOfisID INT,
  TeslimOfisID INT,
  AlisTarihi DATE,
  TeslimTarihi DATE,
  ToplamUcret DECIMAL(10,2),
  Durum ENUM('Onaylandı','İptal Edildi','Tamamlandı'),
  FOREIGN KEY (KullaniciID) REFERENCES Kullanicilar(KullaniciID),
  FOREIGN KEY (AracID) REFERENCES Araclar(AracID),
  FOREIGN KEY (AlisOfisID) REFERENCES Ofisler(OfisID),
  FOREIGN KEY (TeslimOfisID) REFERENCES Ofisler(OfisID)
);


INSERT INTO Rezervasyonlar (KullaniciID, AracID, AlisOfisID, TeslimOfisID, AlisTarihi, TeslimTarihi, ToplamUcret, Durum) VALUES
(82, 15, 1, 1, '2022-09-30', '2022-10-04', 7600.00, 'Onaylandı'),
(14, 87, 9, 7, '2020-05-10', '2020-05-11', 1100.00, 'Onaylandı'),
(30, 65, 10, 4, '2024-09-14', '2024-09-18', 2000.00, 'Onaylandı'),
(36, 1, 3, 3, '2023-10-25', '2023-10-30', 2500.00, 'Onaylandı'),
(98, 44, 2, 3, '2024-01-10', '2024-01-24', 22400.00, 'Onaylandı'),
(34, 6, 8, 8, '2024-03-30', '2024-04-01', 2000.00, 'Onaylandı'),
(81, 80, 6, 6, '2020-10-11', '2020-10-12', 400.00, 'Onaylandı'),
(99, 38, 2, 2, '2021-02-17', '2021-02-24', 7000.00, 'Onaylandı'),
(82, 47, 3, 3, '2022-05-08', '2022-05-19', 20900.00, 'Onaylandı'),
(88, 83, 2, 2, '2021-12-01', '2021-12-10', 6300.00, 'İptal Edildi'),
(21, 60, 7, 10, '2022-06-18', '2022-06-29', 17600.00, 'Onaylandı'),
(99, 100, 1, 2, '2023-07-16', '2023-07-23', 5600.00, 'Onaylandı'),
(28, 73, 6, 9, '2024-06-08', '2024-06-19', 14300.00, 'Onaylandı'),
(34, 18, 8, 8, '2023-08-03', '2023-08-09', 8400.00, 'Onaylandı'),
(86, 8, 4, 4, '2022-12-15', '2022-12-22', 2800.00, 'Onaylandı'),
(94, 81, 2, 2, '2021-10-30', '2021-11-02', 1800.00, 'Onaylandı'),
(69, 95, 7, 7, '2022-07-27', '2022-08-08', 9600.00, 'Onaylandı'),
(11, 41, 1, 1, '2020-09-11', '2020-09-17', 5400.00, 'Onaylandı'),
(75, 84, 1, 1, '2022-03-25', '2022-04-06', 8800.00, 'Onaylandı'),
(54, 84, 2, 2, '2022-11-21', '2022-11-22', 800.00, 'Onaylandı'),
(4, 74, 6, 6, '2023-08-28', '2023-09-07', 8000.00, 'Onaylandı'),
(3, 3, 7, 7, '2023-04-18', '2023-04-23', 7500.00, 'Onaylandı'),
(11, 64, 6, 6, '2023-07-17', '2023-07-31', 14000.00, 'Onaylandı'),
(27, 58, 4, 10, '2022-03-26', '2022-04-06', 8800.00, 'Onaylandı'),
(29, 75, 6, 9, '2020-02-08', '2020-02-16', 7200.00, 'Onaylandı'),
(64, 90, 7, 7, '2023-04-21', '2023-04-26', 5000.00, 'Onaylandı'),
(13, 32, 4, 4, '2025-09-17', '2025-09-29', 4800.00, 'Onaylandı'),
(19, 5, 7, 10, '2021-02-06', '2021-02-09', 2700.00, 'Onaylandı'),
(71, 13, 8, 8, '2022-03-07', '2022-03-12', 6600.00, 'Onaylandı'),
(35, 23, 6, 6, '2020-03-23', '2020-03-26', 2100.00, 'Onaylandı'),
(71, 71, 8, 8, '2021-03-25', '2021-03-30', 5500.00, 'İptal Edildi'),
(12, 30, 3, 1, '2024-05-29', '2024-06-07', 9000.00, 'Onaylandı'),
(44, 23, 2, 2, '2022-07-03', '2022-07-08', 3500.00, 'Onaylandı'),
(89, 93, 4, 4, '2020-10-03', '2020-10-14', 9900.00, 'Onaylandı'),
(52, 2, 3, 3, '2023-01-17', '2023-01-23', 3600.00, 'Onaylandı'),
(15, 58, 2, 8, '2024-10-01', '2024-10-13', 13200.00, 'Onaylandı'),
(95, 40, 3, 3, '2024-10-10', '2024-10-12', 2600.00, 'Onaylandı'),
(78, 66, 4, 4, '2021-08-23', '2021-08-30', 7000.00, 'Onaylandı'),
(4, 14, 4, 4, '2024-06-09', '2024-06-14', 6000.00, 'Onaylandı'),
(72, 45, 4, 3, '2023-01-19', '2023-01-31', 10800.00, 'Onaylandı'),
(26, 52, 9, 9, '2023-09-19', '2023-09-27', 9600.00, 'Onaylandı'),
(43, 94, 1, 6, '2023-06-21', '2023-06-22', 900.00, 'Onaylandı'),
(32, 62, 9, 9, '2023-11-20', '2023-11-21', 500.00, 'Onaylandı'),
(15, 46, 6, 6, '2022-02-23', '2022-03-04', 9900.00, 'İptal Edildi'),
(82, 70, 10, 3, '2020-10-03', '2020-10-09', 6000.00, 'Onaylandı'),
(2, 42, 5, 9, '2025-07-28', '2025-08-08', 6600.00, 'Onaylandı'),
(94, 27, 4, 3, '2021-01-21', '2021-01-27', 6600.00, 'Onaylandı'),
(33, 40, 1, 1, '2025-07-18', '2025-07-20', 2600.00, 'Onaylandı'),
(93, 50, 7, 7, '2021-03-22', '2021-04-03', 14400.00, 'Onaylandı'),
(40, 60, 4, 2, '2023-05-21', '2023-05-26', 8000.00, 'Onaylandı'),
(43, 79, 2, 2, '2021-05-09', '2021-05-18', 9900.00, 'Onaylandı'),
(73, 6, 5, 5, '2025-03-01', '2025-03-03', 2000.00, 'Onaylandı'),
(84, 35, 8, 2, '2023-01-19', '2023-01-28', 8100.00, 'Onaylandı'),
(79, 70, 7, 7, '2021-09-30', '2021-10-02', 3000.00, 'Onaylandı'),
(11, 47, 9, 9, '2025-03-30', '2025-04-02', 5700.00, 'Onaylandı'),
(78, 52, 2, 2, '2024-08-01', '2024-08-11', 12000.00, 'Onaylandı'),
(18, 90, 8, 8, '2021-08-02', '2021-08-07', 2500.00, 'Onaylandı'),
(99, 47, 3, 5, '2020-12-06', '2020-12-10', 7600.00, 'Onaylandı'),
(30, 59, 6, 6, '2021-06-13', '2021-06-24', 12100.00, 'Onaylandı'),
(89, 70, 4, 8, '2020-04-07', '2020-04-14', 10500.00, 'Onaylandı'),
(4, 22, 2, 2, '2023-05-25', '2023-06-02', 7200.00, 'Onaylandı'),
(37, 75, 10, 10, '2020-04-07', '2020-04-11', 3600.00, 'Onaylandı'),
(58, 26, 2, 2, '2021-06-18', '2021-06-19', 1500.00, 'Onaylandı'),
(46, 84, 4, 4, '2025-08-19', '2025-08-29', 8000.00, 'Onaylandı'),
(12, 20, 10, 9, '2024-08-13', '2024-08-23', 14500.00, 'Onaylandı'),
(89, 31, 2, 3, '2022-07-22', '2022-07-29', 4900.00, 'Onaylandı'),
(80, 52, 1, 1, '2024-12-27', '2025-01-04', 9600.00, 'İptal Edildi'),
(16, 43, 2, 9, '2020-11-06', '2020-11-18', 7800.00, 'Onaylandı'),
(29, 32, 10, 10, '2024-07-26', '2024-08-05', 8000.00, 'Onaylandı'),
(92, 97, 8, 8, '2020-01-18', '2020-01-29', 14300.00, 'Onaylandı'),
(57, 12, 5, 5, '2022-09-12', '2022-09-26', 9100.00, 'Onaylandı'),
(37, 58, 7, 7, '2021-11-13', '2021-11-25', 13200.00, 'Onaylandı'),
(10, 18, 3, 3, '2023-07-10', '2023-07-18', 8400.00, 'Onaylandı'),
(32, 6, 9, 9, '2022-10-14', '2022-10-21', 7000.00, 'İptal Edildi'),
(94, 20, 9, 9, '2020-11-18', '2020-11-26', 14500.00, 'Onaylandı'),
(79, 48, 5, 5, '2025-08-06', '2025-08-07', 900.00, 'Onaylandı'),
(65, 77, 4, 4, '2021-01-16', '2021-01-25', 7200.00, 'Onaylandı'),
(75, 71, 9, 9, '2021-07-05', '2021-07-08', 3300.00, 'İptal Edildi'),
(7, 57, 6, 6, '2024-09-09', '2024-09-22', 15600.00, 'Onaylandı'),
(100, 64, 1, 1, '2022-06-18', '2022-06-29', 14000.00, 'Onaylandı'),
(36, 19, 3, 3, '2023-01-03', '2023-01-14', 9900.00, 'Onaylandı'),
(4, 85, 4, 4, '2021-12-26', '2022-01-09', 12300.00, 'Onaylandı'),
(23, 8, 4, 4, '2022-10-14', '2022-10-18', 2800.00, 'Onaylandı'),
(7, 7, 9, 9, '2021-10-01', '2021-10-06', 3100.00, 'Onaylandı'),
(35, 79, 3, 3, '2025-10-28', '2025-11-04', 7700.00, 'Onaylandı'),
(42, 57, 7, 5, '2023-02-05', '2023-02-16', 13200.00, 'Onaylandı'),
(22, 64, 10, 10, '2024-08-11', '2024-08-19', 14000.00, 'Onaylandı'),
(19, 59, 7, 7, '2021-06-27', '2021-06-29', 2200.00, 'Onaylandı'),
(19, 64, 2, 2, '2022-11-08', '2022-11-21', 18200.00, 'Onaylandı'),
(45, 72, 1, 1, '2023-11-16', '2023-11-24', 6400.00, 'Onaylandı'),
(99, 15, 7, 7, '2021-10-29', '2021-11-11', 24700.00, 'Onaylandı'),
(89, 17, 10, 1, '2022-08-03', '2022-08-11', 17600.00, 'Onaylandı'),
(28, 25, 5, 5, '2025-07-04', '2025-07-12', 13600.00, 'Onaylandı'),
(99, 74, 7, 7, '2023-09-08', '2023-09-11', 8000.00, 'Onaylandı'),
(62, 36, 5, 7, '2025-02-22', '2025-02-28', 6000.00, 'Onaylandı'),
(65, 74, 10, 7, '2021-11-14', '2021-11-27', 10400.00, 'Onaylandı'),
(83, 25, 8, 1, '2024-08-20', '2024-08-27', 11900.00, 'Onaylandı'),
(89, 15, 3, 10, '2020-06-16', '2020-06-21', 9500.00, 'Onaylandı'),
(76, 52, 4, 4, '2025-06-05', '2025-06-16', 13200.00, 'Onaylandı'),
(51, 47, 10, 5, '2022-10-22', '2022-10-25', 5700.00, 'Onaylandı'),
(15, 6, 3, 3, '2023-06-21', '2023-06-26', 5000.00, 'Onaylandı'),
(43, 57, 2, 2, '2020-11-21', '2020-11-23', 2200.00, 'Onaylandı'),
(59, 76, 4, 4, '2021-07-30', '2021-08-03', 2800.00, 'Onaylandı'),
(79, 16, 2, 2, '2023-01-16', '2023-01-24', 17600.00, 'Onaylandı'),
(63, 91, 7, 7, '2025-08-06', '2025-08-14', 7200.00, 'Onaylandı'),
(6, 43, 5, 5, '2021-04-01', '2021-04-13', 7800.00, 'Onaylandı'),
(80, 22, 4, 4, '2025-10-10', '2025-10-17', 6300.00, 'Onaylandı'),
(23, 63, 2, 7, '2024-06-12', '2024-06-18', 5400.00, 'Onaylandı'),
(52, 16, 1, 1, '2020-06-08', '2020-06-10', 8800.00, 'Onaylandı'),
(10, 44, 7, 7, '2021-08-19', '2021-08-29', 11200.00, 'Onaylandı'),
(100, 59, 6, 6, '2022-02-08', '2022-02-13', 5500.00, 'Onaylandı'),
(67, 28, 5, 3, '2020-12-28', '2021-01-09', 11400.00, 'Onaylandı'),
(42, 2, 4, 4, '2025-01-21', '2025-01-24', 2700.00, 'Onaylandı'),
(41, 14, 7, 7, '2023-03-16', '2023-03-24', 12000.00, 'Onaylandı'),
(81, 12, 8, 8, '2024-12-10', '2024-12-16', 9100.00, 'Onaylandı'),
(9, 37, 10, 10, '2022-09-01', '2022-09-14', 9100.00, 'Onaylandı'),
(85, 40, 9, 9, '2021-03-24', '2021-04-05', 33800.00, 'Onaylandı'),
(3, 20, 9, 9, '2024-01-02', '2024-01-16', 20300.00, 'Onaylandı'),
(38, 62, 10, 10, '2024-11-30', '2024-12-02', 1000.00, 'Onaylandı'),
(73, 80, 9, 9, '2024-11-01', '2024-11-09', 3200.00, 'Onaylandı'),
(68, 27, 2, 2, '2025-09-06', '2025-09-17', 12100.00, 'Onaylandı'),
(46, 87, 8, 8, '2021-11-15', '2021-11-22', 7700.00, 'Onaylandı'),
(73, 72, 5, 5, '2020-05-11', '2020-05-14', 2400.00, 'Onaylandı'),
(80, 15, 8, 8, '2025-08-25', '2025-08-26', 1900.00, 'Onaylandı'),
(22, 61, 7, 3, '2025-12-10', '2025-12-14', 2000.00, 'Onaylandı'),
(19, 8, 3, 3, '2024-01-02', '2024-01-07', 7000.00, 'Onaylandı'),
(86, 27, 9, 9, '2023-01-17', '2023-01-18', 1100.00, 'Onaylandı'),
(10, 80, 7, 7, '2023-08-25', '2023-09-05', 4400.00, 'Onaylandı'),
(9, 88, 6, 6, '2022-01-08', '2022-01-15', 4900.00, 'İptal Edildi'),
(74, 7, 9, 9, '2025-12-28', '2026-01-09', 13000.00, 'Onaylandı'),
(75, 17, 9, 1, '2025-06-23', '2025-06-27', 8800.00, 'Onaylandı'),
(50, 50, 6, 6, '2020-04-23', '2020-05-05', 14400.00, 'Onaylandı'),
(19, 45, 6, 6, '2023-03-06', '2023-03-09', 3600.00, 'Onaylandı'),
(2, 93, 8, 8, '2020-01-01', '2020-01-03', 1800.00, 'Onaylandı'),
(35, 33, 10, 10, '2023-01-16', '2023-01-17', 700.00, 'Onaylandı'),
(10, 41, 1, 7, '2021-02-17', '2021-02-26', 9000.00, 'Onaylandı'),
(33, 8, 5, 5, '2020-11-01', '2020-11-05', 14000.00, 'Onaylandı'),
(61, 48, 8, 3, '2023-10-07', '2023-10-16', 8100.00, 'Onaylandı'),
(97, 49, 1, 8, '2025-01-16', '2025-01-18', 1400.00, 'Onaylandı'),
(97, 26, 10, 10, '2021-03-03', '2021-03-13', 15000.00, 'Onaylandı'),
(6, 21, 4, 9, '2021-09-29', '2021-10-02', 3300.00, 'Onaylandı'),
(71, 83, 9, 9, '2024-02-29', '2024-03-05', 3500.00, 'Onaylandı'),
(19, 23, 6, 6, '2022-12-19', '2022-12-31', 12600.00, 'Onaylandı'),
(72, 79, 6, 6, '2022-04-07', '2022-04-08', 1100.00, 'İptal Edildi'),
(21, 74, 8, 8, '2023-04-22', '2023-05-06', 11200.00, 'Onaylandı'),
(42, 97, 8, 8, '2022-05-16', '2022-05-19', 3300.00, 'Onaylandı'),
(1, 62, 7, 7, '2020-07-19', '2020-07-21', 1000.00, 'Onaylandı'),
(63, 43, 1, 1, '2023-11-19', '2023-11-23', 2600.00, 'Onaylandı'),
(32, 82, 10, 10, '2023-01-03', '2023-01-10', 4200.00, 'Onaylandı'),
(65, 31, 1, 1, '2024-11-01', '2024-11-10', 6300.00, 'Onaylandı'),
(23, 45, 7, 7, '2025-02-04', '2025-02-10', 5400.00, 'Onaylandı'),
(34, 29, 9, 7, '2023-03-23', '2023-04-04', 8400.00, 'Onaylandı'),
(2, 38, 1, 1, '2025-08-15', '2025-08-19', 4000.00, 'Onaylandı'),
(66, 24, 4, 4, '2025-02-06', '2025-02-07', 1500.00, 'Onaylandı'),
(84, 53, 2, 2, '2021-01-31', '2021-02-06', 5700.00, 'Onaylandı'),
(42, 24, 2, 10, '2022-10-27', '2022-11-03', 10500.00, 'Onaylandı'),
(45, 96, 8, 8, '2021-06-08', '2021-06-11', 8100.00, 'Onaylandı'),
(18, 79, 3, 5, '2025-12-13', '2025-12-15', 2200.00, 'Onaylandı'),
(16, 76, 1, 3, '2022-11-03', '2022-11-10', 5600.00, 'Onaylandı'),
(63, 60, 5, 5, '2022-08-28', '2022-09-03', 9600.00, 'Onaylandı'),
(44, 87, 7, 7, '2020-08-17', '2020-08-19', 1400.00, 'Onaylandı'),
(46, 41, 9, 9, '2022-09-04', '2022-09-06', 3600.00, 'Onaylandı'),
(92, 3, 5, 5, '2021-01-30', '2021-02-02', 4500.00, 'Onaylandı'),
(27, 53, 5, 5, '2024-09-26', '2024-10-01', 9500.00, 'Onaylandı'),
(50, 41, 4, 4, '2021-04-12', '2021-04-15', 8100.00, 'Onaylandı'),
(76, 60, 8, 10, '2024-11-02', '2024-11-05', 4800.00, 'İptal Edildi'),
(28, 90, 7, 10, '2022-11-06', '2022-11-07', 2500.00, 'Onaylandı'),
(9, 4, 7, 7, '2020-02-13', '2020-02-24', 26400.00, 'Onaylandı'),
(42, 38, 8, 8, '2023-09-12', '2023-09-16', 4000.00, 'Onaylandı'),
(79, 43, 5, 5, '2021-07-04', '2021-07-08', 2600.00, 'Onaylandı'),
(49, 86, 9, 9, '2020-01-15', '2020-01-24', 6300.00, 'Onaylandı'),
(5, 37, 1, 1, '2020-06-08', '2020-06-14', 3900.00, 'Onaylandı'),
(99, 79, 4, 4, '2021-10-13', '2021-10-23', 7700.00, 'Onaylandı'),
(32, 55, 7, 5, '2023-04-19', '2023-04-22', 1800.00, 'İptal Edildi'),
(63, 98, 6, 6, '2021-10-30', '2021-11-05', 3600.00, 'Onaylandı'),
(28, 34, 9, 9, '2021-06-14', '2021-06-27', 15600.00, 'Onaylandı'),
(52, 72, 7, 7, '2025-09-25', '2025-10-01', 4800.00, 'Onaylandı'),
(75, 84, 1, 1, '2023-10-26', '2023-10-29', 2400.00, 'Onaylandı'),
(89, 38, 3, 3, '2022-09-14', '2022-09-19', 5000.00, 'Onaylandı'),
(80, 46, 7, 7, '2024-07-05', '2024-07-06', 1100.00, 'Onaylandı'),
(6, 64, 2, 2, '2020-05-23', '2020-06-01', 14000.00, 'Onaylandı'),
(19, 92, 4, 4, '2023-11-01', '2023-11-06', 5500.00, 'Onaylandı'),
(42, 26, 4, 10, '2023-03-19', '2023-03-23', 6000.00, 'Onaylandı'),
(11, 97, 5, 5, '2020-03-20', '2020-03-26', 6600.00, 'Onaylandı'),
(47, 87, 3, 3, '2020-04-28', '2020-05-02', 2800.00, 'Onaylandı'),
(31, 40, 4, 4, '2022-06-18', '2022-06-22', 5200.00, 'İptal Edildi'),
(75, 26, 5, 5, '2024-11-14', '2024-11-22', 12000.00, 'Onaylandı'),
(4, 31, 5, 7, '2024-12-22', '2024-12-29', 4900.00, 'İptal Edildi'),
(89, 91, 10, 10, '2022-08-01', '2022-08-02', 800.00, 'Onaylandı'),
(93, 64, 10, 10, '2020-06-27', '2020-07-11', 9800.00, 'Onaylandı'),
(53, 83, 2, 4, '2023-09-09', '2023-09-14', 3500.00, 'Onaylandı'),
(68, 35, 5, 5, '2020-02-01', '2020-02-02', 900.00, 'Onaylandı'),
(71, 49, 2, 2, '2025-04-29', '2025-05-01', 1400.00, 'Onaylandı'),
(57, 78, 8, 8, '2024-12-01', '2024-12-06', 5400.00, 'Onaylandı'),
(69, 49, 9, 9, '2021-04-27', '2021-05-06', 6300.00, 'Onaylandı'),
(33, 9, 3, 3, '2021-11-09', '2021-11-12', 9300.00, 'Onaylandı'),
(50, 32, 6, 6, '2024-08-26', '2024-08-31', 8000.00, 'Onaylandı'),
(61, 19, 5, 5, '2020-10-24', '2020-10-26', 1800.00, 'Onaylandı'),
(32, 39, 7, 7, '2023-03-29', '2023-04-05', 7700.00, 'Onaylandı'),
(98, 27, 5, 5, '2025-05-12', '2025-05-19', 7700.00, 'Onaylandı'),
(23, 94, 6, 6, '2024-06-18', '2024-06-29', 9900.00, 'Onaylandı'),
(79, 29, 10, 10, '2023-12-03', '2023-12-10', 5600.00, 'Onaylandı'),
(21, 77, 7, 7, '2020-03-05', '2020-03-14', 8100.00, 'Onaylandı'),
(7, 94, 9, 9, '2024-01-04', '2024-01-14', 9000.00, 'Onaylandı'),
(76, 50, 9, 8, '2021-12-01', '2021-12-05', 4800.00, 'İptal Edildi'),
(9, 10, 1, 9, '2025-12-23', '2025-12-30', 4900.00, 'Onaylandı'),
(81, 60, 10, 10, '2024-03-26', '2024-03-30', 6400.00, 'Onaylandı'),
(89, 87, 6, 6, '2020-07-15', '2020-07-23', 8400.00, 'Onaylandı'),
(17, 81, 1, 1, '2020-01-03', '2020-01-09', 5400.00, 'Onaylandı'),
(67, 13, 8, 1, '2022-09-24', '2022-10-04', 6600.00, 'Onaylandı'),
(74, 45, 10, 10, '2023-03-10', '2023-03-16', 8100.00, 'Onaylandı'),
(53, 87, 10, 10, '2022-09-02', '2022-09-04', 1400.00, 'Onaylandı'),
(93, 69, 7, 7, '2020-09-28', '2020-10-02', 4800.00, 'Onaylandı'),
(66, 9, 3, 7, '2022-08-28', '2022-09-02', 4650.00, 'Onaylandı'),
(92, 16, 9, 9, '2023-03-22', '2023-03-29', 8800.00, 'Onaylandı'),
(5, 34, 10, 10, '2025-10-17', '2025-10-24', 8400.00, 'Onaylandı'),
(53, 11, 3, 3, '2023-02-10', '2023-02-20', 5500.00, 'Onaylandı'),
(75, 96, 3, 8, '2020-02-25', '2020-03-09', 9900.00, 'Onaylandı'),
(89, 12, 10, 10, '2023-05-10', '2023-05-16', 9100.00, 'Onaylandı'),
(74, 90, 8, 1, '2024-01-09', '2024-01-22', 32500.00, 'Onaylandı'),
(66, 93, 4, 4, '2021-11-12', '2021-11-13', 900.00, 'Onaylandı'),
(60, 6, 8, 8, '2023-03-05', '2023-03-13', 8000.00, 'Onaylandı'),
(68, 54, 9, 5, '2023-09-06', '2023-09-08', 2200.00, 'Onaylandı'),
(47, 7, 6, 6, '2020-04-28', '2020-05-04', 9300.00, 'Onaylandı'),
(78, 94, 5, 6, '2025-02-04', '2025-02-13', 8100.00, 'Onaylandı'),
(88, 84, 4, 4, '2021-08-11', '2021-08-16', 4000.00, 'Onaylandı'),
(10, 98, 10, 10, '2020-03-15', '2020-03-24', 8100.00, 'Onaylandı'),
(29, 29, 5, 5, '2021-10-30', '2021-11-06', 4900.00, 'Onaylandı'),
(43, 71, 5, 5, '2025-09-17', '2025-09-22', 4500.00, 'Onaylandı'),
(51, 82, 1, 1, '2022-01-05', '2022-01-14', 6300.00, 'Onaylandı'),
(19, 85, 10, 10, '2020-03-13', '2020-03-22', 11100.00, 'Onaylandı'),
(64, 5, 6, 6, '2020-11-25', '2020-12-08', 10800.00, 'Onaylandı'),
(45, 94, 2, 2, '2020-10-28', '2020-11-07', 9000.00, 'Onaylandı'),
(31, 81, 6, 10, '2024-06-11', '2024-06-16', 2700.00, 'Onaylandı'),
(23, 95, 7, 7, '2023-05-03', '2023-05-08', 4000.00, 'Onaylandı'),
(92, 69, 1, 1, '2024-01-25', '2024-01-29', 3200.00, 'Onaylandı'),
(26, 73, 10, 10, '2020-01-27', '2020-02-02', 6600.00, 'Onaylandı'),
(81, 33, 1, 1, '2022-01-30', '2022-02-03', 2800.00, 'Onaylandı'),
(58, 52, 7, 7, '2022-05-23', '2022-05-30', 8400.00, 'Onaylandı'),
(34, 80, 10, 9, '2020-09-09', '2020-09-23', 5600.00, 'Onaylandı'),
(66, 62, 4, 4, '2023-04-14', '2023-04-21', 3500.00, 'Onaylandı'),
(95, 14, 1, 1, '2023-08-31', '2023-09-05', 6000.00, 'Onaylandı'),
(45, 44, 7, 10, '2025-09-26', '2025-10-08', 11200.00, 'Onaylandı'),
(86, 43, 7, 7, '2025-03-01', '2025-03-04', 3900.00, 'Onaylandı'),
(50, 86, 1, 1, '2021-02-02', '2021-02-13', 9900.00, 'Onaylandı'),
(89, 24, 5, 10, '2022-03-07', '2022-03-10', 4500.00, 'Onaylandı'),
(58, 24, 7, 7, '2022-05-06', '2022-05-18', 13500.00, 'Onaylandı'),
(42, 86, 3, 3, '2020-11-09', '2020-11-22', 11700.00, 'Onaylandı'),
(28, 63, 4, 4, '2020-04-18', '2020-04-27', 5400.00, 'Onaylandı'),
(16, 4, 4, 4, '2023-01-21', '2023-01-30', 26400.00, 'Onaylandı'),
(14, 77, 7, 7, '2023-08-17', '2023-08-31', 11340.00, 'Onaylandı'),
(24, 46, 8, 8, '2021-12-21', '2021-12-26', 5500.00, 'Onaylandı'),
(19, 13, 8, 8, '2022-06-18', '2022-06-21', 3300.00, 'Onaylandı'),
(94, 32, 3, 3, '2020-08-29', '2020-08-30', 2000.00, 'Onaylandı'),
(92, 51, 2, 2, '2024-09-20', '2024-09-24', 2800.00, 'Onaylandı'),
(66, 56, 10, 10, '2020-06-11', '2020-06-22', 13200.00, 'Onaylandı'),
(31, 78, 3, 3, '2025-05-24', '2025-06-02', 8100.00, 'Onaylandı'),
(26, 58, 8, 8, '2023-03-06', '2023-03-10', 4400.00, 'Onaylandı'),
(31, 52, 4, 4, '2025-04-09', '2025-04-13', 4800.00, 'Onaylandı'),
(31, 84, 7, 4, '2020-02-25', '2020-03-08', 10400.00, 'Onaylandı'),
(47, 39, 3, 3, '2020-01-22', '2020-01-26', 4400.00, 'Onaylandı'),
(39, 56, 1, 1, '2024-02-15', '2024-02-19', 4400.00, 'Onaylandı'),
(15, 17, 10, 10, '2023-11-04', '2023-11-05', 2200.00, 'Onaylandı'),
(75, 21, 3, 3, '2021-01-27', '2021-02-07', 16500.00, 'Onaylandı'),
(12, 58, 5, 5, '2025-03-18', '2025-03-24', 6600.00, 'Onaylandı'),
(99, 52, 2, 2, '2020-01-24', '2020-01-31', 8400.00, 'Onaylandı'),
(90, 30, 1, 1, '2022-10-14', '2022-10-24', 9000.00, 'Onaylandı'),
(53, 41, 2, 2, '2024-06-02', '2024-06-05', 2700.00, 'Onaylandı'),
(4, 64, 10, 10, '2022-09-28', '2022-10-05', 14000.00, 'Onaylandı');


SELECT * FROM Rezervasyonlar

CREATE TABLE Faturalar (
  FaturaID INT AUTO_INCREMENT PRIMARY KEY,
  RezervasyonID INT UNIQUE,
  FaturaNumarasi VARCHAR(20) UNIQUE,
  FaturaTarihi DATE,
  Tutar DECIMAL(10,2),
  KDV DECIMAL(10,2),
  OdemeYontemi VARCHAR(50),
  FOREIGN KEY (RezervasyonID) REFERENCES Rezervasyonlar(RezervasyonID)
);

INSERT INTO Faturalar (RezervasyonID, FaturaNumarasi, FaturaTarihi, Tutar, KDV, OdemeYontemi)
SELECT
    r.RezervasyonID,
    CONCAT('F', LPAD(r.RezervasyonID, 5, '0')) AS FaturaNumarasi,
    r.TeslimTarihi AS FaturaTarihi,
    r.ToplamUcret AS Tutar,
    ROUND(r.ToplamUcret * 0.20, 2) AS KDV,
    CASE MOD(r.RezervasyonID, 4)
        WHEN 0 THEN 'Kredi Kartı'
        WHEN 1 THEN 'Nakit'
        WHEN 2 THEN 'Banka Kartı'
        ELSE 'Havale/EFT'
    END AS OdemeYontemi
FROM Rezervasyonlar r
WHERE r.Durum = 'Onaylandı';


SELECT * FROM Faturalar


-- ===================
-- Testler
-- ===================

SELECT r.*
FROM Rezervasyonlar r
LEFT JOIN Kullanicilar k ON r.KullaniciID = k.KullaniciID
WHERE k.KullaniciID IS NULL;


SELECT r.*
FROM Rezervasyonlar r
LEFT JOIN Araclar a ON r.AracID = a.AracID
WHERE a.AracID IS NULL;

-- Alış ofisi
SELECT r.*
FROM Rezervasyonlar r
LEFT JOIN Ofisler o ON r.AlisOfisID = o.OfisID
WHERE o.OfisID IS NULL;

-- Teslim ofisi
SELECT r.*
FROM Rezervasyonlar r
LEFT JOIN Ofisler o ON r.TeslimOfisID = o.OfisID
WHERE o.OfisID IS NULL;

-- boş tablo çıktı sonuçlar temiz

-- Kaç tane onaylı rezervasyon var?
SELECT COUNT(*) AS OnayliRezervasyonSayisi
FROM Rezervasyonlar
WHERE Durum = 'Onaylandı';

-- Kaç tane fatura var?
SELECT COUNT(*) AS FaturaSayisi
FROM Faturalar;

-- ikisi de 256 çıktı. eşleşti.

-- Onaylı olup faturası olmayan rezervasyonlar
SELECT r.*
FROM Rezervasyonlar r
LEFT JOIN Faturalar f ON r.RezervasyonID = f.RezervasyonID
WHERE r.Durum = 'Onaylandı'
  AND f.RezervasyonID IS NULL;

-- Herhangi bir rezervasyona bağlı olmayan fatura
SELECT f.*
FROM Faturalar f
LEFT JOIN Rezervasyonlar r ON f.RezervasyonID = r.RezervasyonID
WHERE r.RezervasyonID IS NULL;

-- ikisinde de boş tablo çıktı. testi geçti.

SELECT *
FROM Faturalar f
WHERE f.KDV <> ROUND(f.Tutar * 0.20, 2);

-- kdv doğru hesaplanmış.

SELECT
    r.RezervasyonID,
    r.AracID,
    a.GunlukKiraUcreti,
    DATEDIFF(r.TeslimTarihi, r.AlisTarihi) AS GunSayisi,
    a.GunlukKiraUcreti * DATEDIFF(r.TeslimTarihi, r.AlisTarihi) AS BeklenenTutar,
    r.ToplamUcret AS KayitliTutar
FROM Rezervasyonlar r
JOIN Araclar a ON r.AracID = a.AracID
WHERE r.ToplamUcret <> a.GunlukKiraUcreti * DATEDIFF(r.TeslimTarihi, r.AlisTarihi);

-- testi geçemedi düzenlememiz lazım gereken düzeltme işlemlerini aşağıda yapıyoruz sonrasında yeniden bu testi çağırıp kontrol edeceğiz

UPDATE Rezervasyonlar r
JOIN Araclar a ON r.AracID = a.AracID
SET r.ToplamUcret = a.GunlukKiraUcreti * GREATEST(DATEDIFF(r.TeslimTarihi, r.AlisTarihi), 1);

UPDATE Faturalar f
JOIN Rezervasyonlar r ON f.RezervasyonID = r.RezervasyonID
SET
    f.Tutar = r.ToplamUcret,
    f.KDV   = ROUND(r.ToplamUcret * 0.20, 2);

SELECT * FROM Faturalar

-- düzelttik şimdi tesleri tekrarlayarak devam edebiliriz.

SELECT
    r.RezervasyonID,
    r.AracID,
    a.GunlukKiraUcreti,
    DATEDIFF(r.TeslimTarihi, r.AlisTarihi) AS GunSayisi,
    a.GunlukKiraUcreti * DATEDIFF(r.TeslimTarihi, r.AlisTarihi) AS BeklenenTutar,
    r.ToplamUcret AS KayitliTutar
FROM Rezervasyonlar r
JOIN Araclar a ON r.AracID = a.AracID
WHERE r.ToplamUcret <> a.GunlukKiraUcreti * DATEDIFF(r.TeslimTarihi, r.AlisTarihi);

-- testi başarıyla geçti

SELECT *
FROM Faturalar f
WHERE f.KDV <> ROUND(f.Tutar * 0.20, 2);

-- kdv testini yeniden yaptık. sorun tespit edilmedi.

SELECT f.*, r.AlisTarihi, r.TeslimTarihi
FROM Faturalar f
JOIN Rezervasyonlar r ON f.RezervasyonID = r.RezervasyonID
WHERE f.FaturaTarihi < r.AlisTarihi
   OR f.FaturaTarihi < r.TeslimTarihi;

SELECT *
FROM Rezervasyonlar
WHERE TeslimTarihi <= AlisTarihi;

-- tarihlerde de problemle karşılaşılmadı.

SELECT
    r1.RezervasyonID AS Rez1,
    r2.RezervasyonID AS Rez2,
    r1.AracID,
    r1.AlisTarihi, r1.TeslimTarihi,
    r2.AlisTarihi, r2.TeslimTarihi
FROM Rezervasyonlar r1
JOIN Rezervasyonlar r2
    ON r1.AracID = r2.AracID
   AND r1.RezervasyonID < r2.RezervasyonID
   AND r1.AlisTarihi < r2.TeslimTarihi
   AND r2.AlisTarihi < r1.TeslimTarihi;

-- iki araba iki farklı rezervasyonda olması gibi gerçek hayat kısıtına ters bir durumla karşılaşılmadı.

SELECT *
FROM Rezervasyonlar
WHERE DATEDIFF(TeslimTarihi, AlisTarihi) < 1;

-- 0 gün veya - gün kiralık olamaz

SELECT r.*, a.MevcutOfisID
FROM Rezervasyonlar r
JOIN Araclar a ON r.AracID = a.AracID
WHERE r.AlisOfisID <> a.MevcutOfisID;

-- hata bulduk alış ofis ile mevcut ofis ıd tutmuyor

SELECT r.RezervasyonID, r.AracID, r.TeslimOfisID, a.MevcutOfisID
FROM Rezervasyonlar r
JOIN Araclar a ON r.AracID = a.AracID
WHERE r.TeslimOfisID <> a.MevcutOfisID;


-- Her aracın son (iptal olmayan ve geçmişte bitmiş) rezervasyonuna göre ofisini güncelle
UPDATE Araclar a
JOIN Rezervasyonlar r
  ON r.AracID = a.AracID
  AND r.Durum <> 'İptal Edildi'
  AND r.TeslimTarihi = (
        SELECT MAX(r2.TeslimTarihi)
        FROM Rezervasyonlar r2
        WHERE r2.AracID = a.AracID
          AND r2.Durum <> 'İptal Edildi'
          AND r2.TeslimTarihi <= CURDATE()
      )
SET a.MevcutOfisID = r.TeslimOfisID;

SELECT
    a.AracID,
    a.MevcutOfisID,
    r.RezervasyonID,
    r.TeslimTarihi,
    r.TeslimOfisID
FROM Araclar a
LEFT JOIN Rezervasyonlar r
  ON r.AracID = a.AracID
  AND r.Durum <> 'İptal Edildi'
  AND r.TeslimTarihi = (
        SELECT MAX(r2.TeslimTarihi)
        FROM Rezervasyonlar r2
        WHERE r2.AracID = a.AracID
          AND r2.Durum <> 'İptal Edildi'
          AND r2.TeslimTarihi <= CURDATE()
      )
ORDER BY a.AracID;

SELECT
    r.RezervasyonID,
    r.AracID,
    r.AlisTarihi,
    r.AlisOfisID,
    a.MevcutOfisID
FROM Rezervasyonlar r
JOIN Araclar a ON r.AracID = a.AracID
WHERE r.AlisTarihi >= CURDATE()
  AND r.Durum <> 'İptal Edildi'
  AND r.AlisOfisID <> a.MevcutOfisID;

SELECT *
FROM (
    SELECT
        a.AracID,
        a.MevcutOfisID,
        r.RezervasyonID,
        r.TeslimTarihi,
        r.TeslimOfisID
    FROM Araclar a
    LEFT JOIN Rezervasyonlar r
      ON r.AracID = a.AracID
      AND r.Durum <> 'İptal Edildi'
      AND r.TeslimTarihi = (
            SELECT MAX(r2.TeslimTarihi)
            FROM Rezervasyonlar r2
            WHERE r2.AracID = a.AracID
              AND r2.Durum <> 'İptal Edildi'
              AND r2.TeslimTarihi <= CURDATE()
        )
) x
WHERE x.RezervasyonID IS NOT NULL
  AND x.MevcutOfisID <> x.TeslimOfisID;

-- Tüm araçlar için “son teslim ofisi = şu anki MevcutOfisID” kuralı zaten sağlanmış demektir

-- Bugün kirada olması gereken ama 'Kirada' işaretli olmayan araçlar
SELECT DISTINCT a.AracID, a.Durum, r.*
FROM Araclar a
JOIN Rezervasyonlar r ON r.AracID = a.AracID
WHERE r.Durum <> 'İptal Edildi'
  AND CURDATE() BETWEEN r.AlisTarihi AND r.TeslimTarihi
  AND a.Durum <> 'Kirada';


-- Durumu 'Bakımda' olup, gelecekte onaylı rezervasyonu da olan araçlar
SELECT a.AracID, a.Durum, r.*
FROM Araclar a
JOIN Rezervasyonlar r ON r.AracID = a.AracID
WHERE a.Durum = 'Bakımda'
  AND r.Durum = 'Onaylandı'
  AND r.AlisTarihi >= CURDATE();


ALTER TABLE Rezervasyonlar
MODIFY COLUMN Durum ENUM('Beklemede', 'Onaylandı', 'Devam Ediyor', 'İptal Edildi', 'Tamamlandı')
COLLATE utf8mb4_unicode_ci;

ALTER TABLE Ofisler
ADD COLUMN Eposta VARCHAR(100) NULL;

ALTER TABLE Ofisler
ADD COLUMN Sifre VARCHAR(100) NULL;

ALTER TABLE Ofisler
ADD COLUMN SifreHash VARCHAR(255) NULL;

ALTER TABLE Ofisler
ADD CONSTRAINT unique_ofis_eposta UNIQUE (Eposta);

UPDATE Ofisler
SET Sifre = '1234',
    SifreHash = SHA2('1234', 256);

UPDATE Ofisler SET Eposta = 'ankara@ofis.com' WHERE OfisID = 1;
UPDATE Ofisler SET Eposta = 'istanbul.avrupa@ofis.com' WHERE OfisID = 2;
UPDATE Ofisler SET Eposta = 'istanbul.anadolu@ofis.com' WHERE OfisID = 3;
UPDATE Ofisler SET Eposta = 'izmir@ofis.com' WHERE OfisID = 4;
UPDATE Ofisler SET Eposta = 'antalya@ofis.com' WHERE OfisID = 5;
UPDATE Ofisler SET Eposta = 'bursa@ofis.com' WHERE OfisID = 6;
UPDATE Ofisler SET Eposta = 'adana@ofis.com' WHERE OfisID = 7;
UPDATE Ofisler SET Eposta = 'trabzon@ofis.com' WHERE OfisID = 8;
UPDATE Ofisler SET Eposta = 'gaziantep@ofis.com' WHERE OfisID = 9;
UPDATE Ofisler SET Eposta = 'eskisehir@ofis.com' WHERE OfisID = 10;


-- REZERVASYON OLUŞTURMA

INSERT INTO Rezervasyonlar (
    KullaniciID,
    AracID,
    AlisOfisID,
    TeslimOfisID,
    AlisTarihi,
    TeslimTarihi,
    ToplamUcret,
    Durum
) VALUES (
    1,              -- ÖRNEK: Kullanıcı ID
    5,              -- ÖRNEK: Araç ID
    1,              -- ÖRNEK: Alış Ofis ID
    1,              -- ÖRNEK: Teslim Ofis ID
    '2025-10-20',   -- ÖRNEK: Başlangıç
    '2025-10-25',   -- ÖRNEK: Bitiş
    5000.00,        -- ÖRNEK: Tutar
    'Onaylandı'
);



-- KULLANICI GEÇMİŞİNİ GETİRME

SELECT
    r.RezervasyonID,
    r.AlisTarihi,
    r.TeslimTarihi,
    r.ToplamUcret,
    r.Durum,
    a.Marka,
    a.Model,
    a.Plaka,
    o1.OfisAdi AS AlisOfisi,
    o2.OfisAdi AS TeslimOfisi
FROM Rezervasyonlar r
JOIN Araclar a ON r.AracID = a.AracID
JOIN Ofisler o1 ON r.AlisOfisID = o1.OfisID
JOIN Ofisler o2 ON r.TeslimOfisID = o2.OfisID
WHERE r.KullaniciID = 1 -- ÖRNEK: 1 Numaralı Kullanıcı
ORDER BY r.AlisTarihi DESC;



-- REZERVASYON İPTALİ

UPDATE Rezervasyonlar
SET Durum = 'İptal Edildi'
WHERE RezervasyonID = 10 -- ÖRNEK: 10 Numaralı Rezervasyon
  AND Durum = 'Onaylandı';


-- FATURA KESME

INSERT INTO Faturalar (
    RezervasyonID,
    FaturaNumarasi,
    FaturaTarihi,
    Tutar,
    KDV,
    OdemeYontemi
) VALUES (
    5,              -- ÖRNEK: Rezervasyon ID (Daha önce faturası olmamalı!)
    'FTR2025999',   -- ÖRNEK: Fatura No
    CURDATE(),      -- Bugünün tarihi
    1500.00,        -- Tutar
    300.00,         -- KDV
    'Kredi Kartı'
);


-- ARAÇ ARAMA



SELECT * FROM Araclar
WHERE MevcutOfisID = 1             -- ÖRNEK: Kullanıcının seçtiği ofis
  AND Durum != 'Bakımda'           -- Araç bozuk olmamalı
  AND YakitTipi = 'Dizel'          -- (Varsa) Filtre
  AND VitesTuru = 'Otomatik'       -- (Varsa) Filtre
  AND AracID NOT IN (
      SELECT AracID FROM Rezervasyonlar
      WHERE Durum IN ('Onaylandı', 'Kirada') -- Hem gelecekteki hem şu anki kiralamaları kontrol et
      AND (
          -- SENARYO 1: Rezervasyonun BAŞLANGICI benim aralığımda mı?
          (AlisTarihi BETWEEN '2025-10-10' AND '2025-10-15')
          OR
          -- SENARYO 2: Rezervasyonun BİTİŞİ benim aralığımda mı?
          (TeslimTarihi BETWEEN '2025-10-10' AND '2025-10-15')
          OR
          -- SENARYO 3 (Kritik): Rezervasyon benim tarihlerimi tamamen KAPLIYOR MU?
          -- (Örn: Adam 1-30 Ekim kiralamış, ben 10-15 Ekim istiyorum)
          (AlisTarihi < '2025-10-10' AND TeslimTarihi > '2025-10-15')
      )
  );


-- KULLANICI KAYDI

INSERT INTO Kullanicilar (Ad, Soyad, Eposta, SifreHash, Telefon, EhliyetNumarasi)
VALUES (%s, %s, %s, %s, %s, %s);


-- YENI ARAC EKLEME

INSERT INTO Araclar (Plaka, Marka, Model, Yil, VitesTuru, YakitTipi, GunlukKiraUcreti, MevcutOfisID, Durum)
VALUES (%s, %s, %s, %s, %s, %s, %s, %s, 'Müsait');

-- Araç Fiyat/Durum Güncelleme:

UPDATE Araclar
SET GunlukKiraUcreti = %s, Durum = %s
WHERE AracID = %s;

-- ARAC SILME

DELETE FROM Araclar WHERE AracID = %s;


-- YONETICI TARAFI

-- TOPLAM CIRO
SELECT SUM(ToplamUcret) FROM Rezervasyonlar WHERE Durum = 'Tamamlandı';

-- Şu An Kirada Olan Araç Sayısı
SELECT COUNT(*) FROM Araclar WHERE Durum = 'Kirada';

-- En Popüler Ofis (En çok kiralama yapılan)
SELECT o.OfisAdi, COUNT(r.RezervasyonID) as Sayi
FROM Rezervasyonlar r
JOIN Ofisler o ON r.AlisOfisID = o.OfisID
GROUP BY o.OfisAdi
ORDER BY Sayi DESC
LIMIT 1;
