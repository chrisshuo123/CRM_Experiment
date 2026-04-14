use daftarNama_palugada;

/* - - 1 - STRUKTUR RESI DN - - */

/* 1.1 - table SKU Daftar Nama */

create table skuDaftarNama ( /* <-- belum di-create */
	idSkuDaftarNama int(10) primary key auto_increment, /* (jika varchar maka tidak bisa auto-increment. Ingin jika id nya: RDN000 alias Resi Daftar Nama. */
    tanggalInput timestamp not null default current_timestamp,
    idMetodePenjualan_fk int(10) not null,
    idKodeTempat_fk int(10) not null,
    catatanTambahan varchar(100)
);

ALTER TABLE skuDaftarNama
MODIFY COLUMN idSkuDaftarNama VARCHAR(10) NOT NULL,
DROP PRIMARY KEY,
ADD PRIMARY KEY (idSkuDaftarNama);

select * from skuDaftarNama;
/*NOTE!! Untuk skuDaftarNama bagian Primary Key WAJIB DIISI MANUAL! */

ALTER TABLE skuDaftarNama
MODIFY COLUMN idMetodePenjualan_fk int(10) NULL,
MODIFY COLUMN idKodeTempat_fk int(10) NULL;

/* RALAT: Urutan Tabel SKUDaftarNama sesuai dengan Kode Resi pada DN di G-Drive: */

/* Ralat-1: menambahkan FK KodeTanggal dan SKUDaftarNama: */
alter table skuDaftarNama
add column idKodeTanggal_fkSkuDaftarNama int(10) after idKodeTempat_fk;
alter table skuDaftarNama
add constraint idKodeTanggal_fkSkuDaftarNama foreign key (idKodeTanggal_fkSkuDaftarNama)
REFERENCES kodetanggal (idKodeTanggal);

alter table skuDaftarNama
add column idProduk_fkSkuDaftarNama int(10) after idKodeTempat_fk;
alter table skuDaftarNama
add constraint idProduk_fkSkuDaftarNama foreign key (idProduk_fkSkuDaftarNama)
references produk (idProduk);

/* Ralat-2: Merubah nama Column FK menjadi yang 'fkSkuDaftarNama': */

show create table skudaftarnama;

/* Tidak ditemukan FK Constraint pada column FK berikut, sehingga langsung saja
kita renamekan bawah ini: */
alter table skuDaftarNama
rename column idMetodePenjualan_fk to idMetodePenjualan_fkSkuDaftarNama,
rename column idKodeTempat_fk to idKodeTempat_fkSkuDaftarNama;

/* Tambahkan Constraint FK disini: */
alter table skuDaftarNama
add constraint idMetodePenjualan_fkSkuDaftarNama foreign key (idMetodePenjualan_fkSkuDaftarNama)
REFERENCES metodejualan (idMetodeJualan);
alter table skuDaftarNama
add constraint idKodeTempat_fkSkuDaftarNama foreign key (idKodeTempat_fkSkuDaftarNama)
REFERENCES kodetempat (idKodeTempat);

/* URUTAN KODE RESI BERDASARKAN URUTAN TABEL:
1 - metodejualan v
2 - kodetempat v
3 - produk v
4 - kodetanggal v
*/

/* Rubah catatanTambahan dari varchar(100) menjadi LONGTEXT: */
alter table skuDaftarNama
modify column catatanTambahan LONGTEXT;

select * from skuDaftarNama;

/* 1.2 - table Kode Tanggal */
create table kodeTanggal ( /* Belum di-create */
	idKodeTanggal int(10) primary key auto_increment,
    tanggalInput timestamp not null default current_timestamp,
    hari int(10) not null,
    bulan int(10) not null,
    tahun int(10) not null
);

/* ralat tanggal pada kolom bulan dari int(10) menjadi varchar(100) */
alter table kodetanggal
modify column bulan varchar(100) not null;

select * from kodeTanggal;

/* 1.3 - Table Metode Jualan */

create table metodeJualan ( /* <-- Belum Di-Create */
	idMetodeJualan int(10) primary key auto_increment,
    tanggalInput timestamp not null default current_timestamp,
    metodeJualan varchar(100) not null
);

alter table metodeJualan
add column kodeMetodeJualan varchar(10);
select * from metodeJualan;

/* 1.4 - Table Kode Tempat */

create table kodeTempat (
	idKodeTempat int(10) primary key auto_increment,
    tanggalInput timestamp not null default current_timestamp,
    namaTempat varchar(100) not null,
    lantai varchar(100) not null, /* karna ada istilah lantai G, UG, dkk... Gada lantai = G */
    blok varchar(100)
);

select * from kodeTempat;

/* 1.5 - Table Kategori */
/* Untuk tabel kategori, sudah dibuat pada bagian bawah No. 2 */

/* - - 2 - STRUKTUR TABEL DN_PALUGADA - - */

/* 2.1 - Table Perusahaan */
create table perusahaan
(
	idPerusahaan int (10) primary key auto_increment,
	date DATETIME,
    namaPerusahaan varchar(100) not null,
    jenisUsaha varchar(100) not null,
    /*foreign key (idProduk) references produk(idProduk),*/
    alamat varchar(100)
    /*foreign key (idProfil) references kontak(idProfil)*/
) ENGINE = InnoDB;

alter table perusahaan
	add column tanggalKunjungan date after idPerusahaan;
    
alter table perusahaan
	change column date tanggal TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER idPerusahaan;
    
alter table perusahaan
	rename column tanggal to tanggalInput;
    
/* Menambahkan FK pada table Perusahaan */
alter table perusahaan
	add column idProduk_fk int(10) after jenisUsaha,
    add column idKontak_fk int(10) after alamat;
	
/* NOTE: ada kesalahan dalam penamaan idKontak_fk, yg seharusnya idProfil_fk */
alter table perusahaan
	rename column idKontak_fk to idProfil_fk;
    
/* Menambahkan Foreign Key bagi masing2 FK pada table Perusahaan */
alter table perusahaan
	ADD CONSTRAINT idProduk_fk FOREIGN KEY (idProduk_fk)
	REFERENCES produk (idProduk);
    
alter table perusahaan
	ADD CONSTRAINT idProfil_fk FOREIGN KEY (idProfil_fk)
	REFERENCES profil (idProfil);

/* RALAT: Penyesuaian nama FK pada tabel perusahaan */

alter table perusahaan
	rename column idProfil_fk to idProfil_fkPerusahaan;
alter table perusahaan
	rename column idProduk_fk to idProduk_fkPerusahaan;
    
alter table perusahaan
	drop foreign key idProfil_fk,
    drop foreign key idProduk_fk;
    
alter table perusahaan
	ADD CONSTRAINT idProfil_fkPerusahaan FOREIGN KEY (idProfil_fkPerusahaan)
	REFERENCES profil (idProfil),
    ADD CONSTRAINT idProduk_fkPerusahaan FOREIGN KEY (idProduk_fkPerusahaan)
	REFERENCES produk (idProduk);

/* RALAT: Tidak diperlukan FK Kategori pada Tabel Perusahaan, berhub masing2 Perusahaan
ada yang Palugada */
alter table perusahaan
	drop constraint idKategori_fkPerusahaan;
alter table perusahaan
	drop column idKategori_fkPerusahaan;

/* Ralat: pada Column profil tidak diperlukan FK idPerusahaan, sehingga perlu didropkan */

alter table profil
	drop foreign key idPerusahaan_fk;
alter table profil
	drop column idPerusahaan_fk;

/* Ralat: menambahkan FK idInteraksi setelah column 'tanggalKunjungan' */
alter table perusahaan
	add column idInteraksi_fkPerusahaan int(10) after tanggalInput;
alter table perusahaan
	ADD CONSTRAINT idInteraksi_fkPerusahaan FOREIGN KEY (idInteraksi_fkPerusahaan)
	REFERENCES interaksi (idInteraksi);

/* Menambahkan Deskripsi pada Table Perusahaan (Is Nullable) */
alter table perusahaan
add column deskripsi longtext after idProfil_fkPerusahaan;

/* Untuk FK produk, FK profil, sudah ditampung pada table produkbanyak, dan table
profilbanyak, sehingga FK produk dan FK profil bisa didropkan */
alter table perusahaan
drop constraint idProduk_fkPerusahaan,
drop constraint idProfil_fkPerusahaan;

alter table perusahaan
drop column idProduk_fkPerusahaan,
drop column idProfil_fkPerusahaan;

/* Dibagian akhir awal Column Perusahaan (setelah column tanggalInput), tambahkan
FK idSkuDaftarNama */
alter table perusahaan
add column idSkuDaftarNama_fkPerusahaan int(10) after tanggalInput;

alter table perusahaan
modify column idSkuDaftarNama_fkPerusahaan varchar(10);

alter table perusahaan
ADD CONSTRAINT idSkuDaftarNama_fkPerusahaan FOREIGN KEY (idSkuDaftarNama_fkPerusahaan)
REFERENCES skudaftarnama (idSkuDaftarNama);

select * from skuDaftarNama;
select * from perusahaan;

/* Untuk Perusahaan, terkadang terdapat Perusahaan yang jalannya secara Palugada,
untuk itu kita membutuhkan sebuah Table KategoriBanyak m:n yang bisa ngelist kategori
perusahaan dalam jumlah yang banyak */
/* Untuk table KategoriBanyak di Create Table setelah bagian Table Kategori */

/* Pada Tabel Produk, hilangkan FK Kategori lalu pindahkan ke Tabel Perusahaan */
select * from produk;
select * from kategori;
select * from perusahaan;

alter table perusahaan
	add column idKategori_fkPerusahaan int(10) after idProduk_fkPerusahaan;
alter table perusahaan
	add constraint idKategori_fkPerusahaan foreign key (idKategori_fkPerusahaan)
    references kategori (idKategori);

/* Removing column FK 'Interaksi', sambungkan FK Interaksi dengan Tabel Kontak (1:1) */
alter table perusahaan
	drop constraint idInteraksi_fkPerusahaan;
alter table perusahaan
	drop column idInteraksi_fkPerusahaan;

select * from perusahaan;

/* Removing FK Kategori On Table Produk */
alter table produk
	drop foreign key idKategori_fkProduk;
alter table produk
	drop column idKategori_fkProduk;
select * from produk;
/* 2.2 - table produk */
create table produk
(
	idProduk INT(10) primary key not null, /*NOTE: lupa nambah A_I, sudah ditambah dibwh */
    tanggalInput timestamp not null default current_timestamp,
    namaProduk VARCHAR(100) not null,
    /*foreign key (idKategori_fk) references kategori(idKategori),*/
    deskripsiProduk varchar(100)
);

alter table produk
	modify idProduk int(10) auto_increment;

/* Menambahkan foreign key pada table produk: */
alter table produk
	add column idKategori_fk int(10) after namaProduk;

alter table produk
	ADD CONSTRAINT idKategori_fk FOREIGN KEY (idKategori_fk)
	REFERENCES kategori (idKategori);

/* Penyesuaian nama fk pada table produk: */
alter table produk
	rename column idKategori_fk to idKategori_fkProduk;
    
alter table produk
	drop foreign key idKategori_fk;
    
alter table produk
	add constraint idKategori_fkProduk foreign key (idKategori_fkProduk)
    references kategori (idKategori);

/* RALAT: Mengubah column deskripsiProduk dari varchar(100) menjadi LONGTEXT */
alter table produk
	modify column deskripsiProduk LONGTEXT;

/* Ralat: Menambahkan Kolom 'kodeProduk' setelah 'namaProduk' (cont: DES, SS, IT, dkk) */
alter table produk
	add column kodeProduk varchar(100) after namaProduk;

select * from produk;

/* Bikin Tabel M:N bagi Produk */

CREATE TABLE produkbanyak (
	idProdukBanyak INT(10) primary key auto_increment,
    idPerusahaan_fkProdukBanyak int(10),
    idProduk_fkProdukBanyak int(10)
);

alter table produkbanyak
	ADD CONSTRAINT idPerusahaan_fkProdukBanyak FOREIGN KEY (idPerusahaan_fkProdukBanyak)
	REFERENCES perusahaan (idPerusahaan),
    ADD CONSTRAINT idProduk_fkProdukBanyak FOREIGN KEY (idProduk_fkProdukBanyak)
	REFERENCES produk (idProduk);

select * from produkbanyak;
describe produkbanyak;

/* 2.3 - table kategori */

create table kategori
(
	idKategori int(10) primary key not null auto_increment,
    tanggalInput timestamp not null default current_timestamp,
    namaKategori varchar(100)
);

select * from kategori;

/* 2.3.1 - Table Kategori Banyak */
/* Ini khusus guna ngeList Kategori Perusahaan Bergerak pada bidang mana.  Di Indonesia,
seringkali Perusahaan tidak punya Sistem / Manajemen yang Jelas maupun Diskriminasi Kerja,
sehingga Kategori seringkali tidak bisa bergerak satu, namun secara Palugada. */

create table KategoriBanyak
(
	idKategoriBanyak int(10) primary key auto_increment not null,
    pkPerusahaan_fkKategoriBanyak int(10) not null,
    pkKategori_fkKategoriBanyak int(10) not null
);

alter table KategoriBanyak
add FOREIGN KEY (pkPerusahaan_fkKategoriBanyak) REFERENCES perusahaan(idPerusahaan),
add FOREIGN KEY (pkKategori_fkKategoriBanyak) REFERENCES kategori(idKategori);

select * from kategoribanyak;

/* 2.4 - table profil */

create table profil
(
	idProfil int(10) primary key not null auto_increment,
    tanggalInput timestamp not null default current_timestamp,
    /*foreign key (idPerusahaan_fk) references perusahaan(idPerusahaan),*/
    namaKontak varchar(100) not null,
    jabatan varchar(100) not null
    /*foreign key (idKontak_fk) references kontak (idKontak),*/
);

/* Menambahkan foreign key pada tabel Profil */

alter table profil
	add column idPerusahaan_fk int(10) after tanggalInput,
    add column idKontak_fk int(10) after jabatan;

alter table profil
	ADD CONSTRAINT idPerusahaan_fk FOREIGN KEY (idPerusahaan_fk)
	REFERENCES perusahaan (idPerusahaan),
    ADD CONSTRAINT idKontak_fk FOREIGN KEY (idKontak_fk)
	REFERENCES kontak (idKontak);

/*RALAT: Karena table profil dan kontak adalah 1:n, maka fk kontak pada table profil perlu
di-takedown: */
alter table profil
drop foreign key idKontak_fk;
alter table profil
drop column idKontak_fk;

select * from profil;

/* Bikin sebuah Relasi M:N bagi Table Profil */
CREATE TABLE profilbanyak (
	idProfilBanyak int(10) primary key auto_increment,
    idPerusahaan_fkProfilBanyak int(10),
    idProfil_fkProfilBanyak int(10)
);

alter table profilbanyak
	ADD CONSTRAINT idPerusahaan_fkProfilBanyak FOREIGN KEY (idPerusahaan_fkProfilBanyak)
	REFERENCES perusahaan (idPerusahaan),
    ADD CONSTRAINT idProfil_fkProfilBanyak FOREIGN KEY (idProfil_fkProfilBanyak)
	REFERENCES profil (idProfil);

select * from profilbanyak;
select * from produkbanyak;
describe profilbanyak;

/* 2.5 - table interaksi */

create table interaksi
(
	idInteraksi int(10) primary key not null auto_increment,
    tanggalInput timestamp not null default current_timestamp,
    /*foreign key (idPerusahaan_fk) references perusahaan (idPerusahaan),*/
    /*foreign key (idProduk_fk) references produk (idProduk),*/
    tanggalFollowUp datetime not null,
    followUpKe int(10) not null,
    catatan varchar(100)
);

/* Add Foreign Key for table Interaksi */

alter table interaksi
	add column idPerusahaan_fk int(10) after tanggalInput;
alter table interaksi
	add column idProduk_fk int(10) after idPerusahaan_fk;
    
/* Ganti nama FK menjadi lebih spesifik sesuai nama table: */
alter table interaksi
	rename column idPerusahaan_fk to idPerusahaan_fkInteraksi,
    rename column idProduk_fk to idProduk_fkInteraksi;
    
alter table interaksi
	add constraint idPerusahaan_fkInteraksi foreign key (idPerusahaan_fkInteraksi)
    references perusahaan (idPerusahaan),
    add constraint idProduk_fkInteraksi foreign key (idProduk_fkInteraksi)
    references produk (idProduk);

/* Untuk FK karena sudah benar semua, maka dibagian ini tidak diperlukan penyesuaian rename FK pada table interaksi. */

/* RALAT: table interaksi tidak membutuhkan FK, dimana Interaksi dihubungkan langsung dengan idPerusahaan */
alter table interaksi
	drop foreign key idPerusahaan_fkInteraksi,
    drop foreign key idProduk_fkInteraksi;
alter table interaksi
	drop column idPerusahaan_fkInteraksi,
    drop column idProduk_fkInteraksi;

/* Bikin FK profil pada table Interaksi */
alter table interaksi
	add column idProfil_fkInteraksi int(10) after catatan;
alter table interaksi
	drop constraint idProfil_fkInteraksi;
alter table interaksi
	add constraint idProfil_fkInteraksi foreign key (idProfil_fkInteraksi)
    references profil (idProfil);
    
/* Tambahkan idStatus FK pada bagian column terakhir */
alter table interaksi
	add column idStatus_fkInteraksi int(10) after idProfil_fkInteraksi;
alter table interaksi
	add constraint idStatus_fkInteraksi foreign key (idStatus_fkInteraksi)
    references status (idStatus);

/* Merubah column 'Catatan' dari VARCHAR(100) menjadi LONGTEXT */
alter table interaksi
	modify catatan LONGTEXT;

/* Merubah Column 'followUpKe' dari NotNull, menjadi Is Null */
alter table interaksi
	modify followUpKe int(10) NULL;

select * from interaksi;
describe interaksi;

/* ------ALERT! SAMPAI DISINI, BAGIAN ATAS YANG FK FK DIRENAME SESUAI NAMA TABEL MASING2!! */

/* 2.6 - table kontak */

create table kontak
(
	idKontak int(10) primary key not null auto_increment,
    tanggalInput timestamp not null default current_timestamp,
    alamatCabang longtext,
    nomorWA  int(10),
    email varchar(100)
    /*foreign key (idKontakSekunder_fkKontak) references produk (idKontakSekunder),*/
);

/* Ralat DataType nomorWA dari int(10) menjadi Varchar(20) */
alter table kontak
modify nomorWA varchar(30);

/* Menambahkan FK pada table Kontak */
alter table kontak
	add column idKontakSekunder_fkKontak int(10) after email;

alter table kontak
	add constraint idKontakSekunder_fkKontak foreign key (idKontakSekunder_fkKontak)
    references kontaksekunder (idKontakSekunder);

/* RALAT: Menambahkan Kolom Deskripsi pada Kontak (Is Nullable) */
alter table kontak
	add column deskripsiSingkat longtext after idKontakSekunder_fkKontak;

select * from kontak;
/* Sampai disini, nama fk di table kontak sudah benar semua */

/* Tambahkan FK Interaksi pada Table Kontak ini */
alter table kontak
add column idInteraksi_fkKontak int(10) after tanggalInput;
alter table kontak
add constraint idInteraksi_fkKontak foreign key (idInteraksi_fkKontak)
references interaksi (idInteraksi);

/* EH MAAF, FK Interaksi tidak diperlukan karena Kontak digunakan untuk menyimpan
sekumpulan Kontak dari si Profil, dimana interaksi FU yang benar adalah terhubung
dengan si Profil (1:n).
Dengan ini, yang benar adalah '1 Profil bisa di Follow-Up lebih dari 2x (1:n) ' */
alter table kontak
drop constraint idInteraksi_fkKontak;
alter table kontak
drop column idInteraksi_fkKontak;

/*RALAT: Karena table profil dan kontak adalah 1:n, alias kontak bisa >2 per profil, maka idProfil_fkKontak perlu
diimplementasi ke table kontak, yang posisinya tepat disebelah kanannya column
tanggalInput: */
alter table kontak
add idProfil_fkKontak int(10) after tanggalInput;
alter table kontak
add constraint idProfil_fkKontak foreign key (idProfil_fkKontak)
references profil(idProfil);

/* Tambahkan Fk idProfil pada Table Interaksi dibagian Column paling terakhir */
alter table interaksi
add column idProfil_fkInteraksi int(10) after catatan;
alter table interaksi
add constraint idProfil_fkInteraksi foreign key (idProfil_fkInteraksi)
references interaksi (idInteraksi);

select * from interaksi;
select * from profil;
select * from kontak;

/* 2.6.1 - table kontak sekunder */

create table kontakSekunder
(
	idKontakSekunder int(10) primary key not null auto_increment,
    tanggalInput timestamp not null default current_timestamp,
    instagram varchar(100),
    facebook varchar(100),
    twitterX varchar(100),
    situsWeb varchar(100),
    tokopedia varchar(100),
    shopee varchar(100)
);

select * from kontakSekunder;

create table status (
	idStatus int(10) primary key auto_increment,
    status varchar(100) not null
);
/* Ada kelupaan menambahkan tanggalInput pada table Status */
alter table status
add column tanggalInput timestamp not null default current_timestamp after idStatus;

/* Menambahkan List Status */
insert into status(status)
values ('Prospek');
insert into status(status)
values ('FU Last on Progress');

select * from status;

/* BIKIN Sekalian M:N buat Kontaksekunderbanyak (ditemukan 1 perush ada lebih dari 2 IG) : */
create table kontaksekunderbanyak (
	idKontakSekunderBanyak int(10) primary key not null auto_increment,
    tanggalInput timestamp not null default current_timestamp,
    idKontak_fkKontakSekunderBanyak int(10),
    idKontakSekunder_fkKontakSekunderBanyak int(10)
);

ALTER TABLE kontaksekunderbanyak
ADD CONSTRAINT idKontak_fkKontakSekunderbanyak
FOREIGN KEY (idKontak_fkKontakSekunderbanyak) REFERENCES kontak(idKontak);
ALTER TABLE kontaksekunderbanyak
ADD CONSTRAINT idKontakSekunder_fkKontakSekunderBanyak
FOREIGN KEY (idKontakSekunder_fkKontakSekunderBanyak) REFERENCES kontaksekunder(idKontakSekunder);

/* - - 3 - INPUT QUERY  */

/* 1 - RESI DN */

/* 2 - DN */
/*Tata Cara Input DN:*/

/*1 - tabel Status
idStatus, status*/
insert into status (status)
values 
('blacklist'),
('Tanda Tanya?'),
('Misscall'),
('Ga Prospek / Ga Mau Dulu');

select * from status;

/*2 - tabel MetodeJualan
idMetodeJualan, tanggalInput, metodeJualan*/

insert into metodejualan(metodeJualan)
values
	('Door-2-Door'),
    ('Canvassing'),
    ('Direct Selling'),
    ('Telemarketing'),
    ('Retail Selling'),
    ('Online Selling (E-Commerce)'),
    ('Network Marketing (Multi-Level Marketing / MLM)'),
    ('Pop-Up Shop'),
    ('Outbound Sales'),
    ('Inbound Sales'),
    ('Event Selling'),
    ('Affiliate Marketing'),
    ('Social Selling'),
    ('Consultative Selling'),
    ('Cross-Selling'),
    ('Up-Selling');
    
update metodeJualan
set kodeMetodeJualan = case
	when idMetodeJualan = 1 then 'D2D'
    when idMetodeJualan = 2 then 'CVG'
    when idMetodeJualan = 3 then 'DSELL'
    when idMetodeJualan = 4 then 'TELE'
    when idMetodeJualan = 5 then 'RETAIL'
	when idMetodeJualan = 6 then 'ONLINE'
    when idMetodeJualan = 7 then 'MLM'
    when idMetodeJualan = 8 then 'POP'
    when idMetodeJualan = 9 then 'OBDS'
    when idMetodeJualan = 10 then 'IBDS'
    when idMetodeJualan = 11 then 'EVENT'
    when idMetodeJualan = 12 then 'AFFM'
    when idMetodeJualan = 13 then 'SOCIAL'
    when idMetodeJualan = 14 then 'CONSULT'
    when idMetodeJualan = 15 then 'CROSSS'
    when idMetodeJualan = 16 then 'UPSELL'
    when idMetodeJualan = 17 then 'BERKAS'
    else kodeMetodeJualan
end
where idMetodeJualan IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17);

select * from metodejualan;

/*3 - table Kategori
idKategori, tanggalInput, namaKategori*/

insert into kategori (namaKategori)
values
	('Salon'),
    ('Klinik'),
    ('Beauty Bar'),
    ('Cleaning'),
    ('Barbershop'),
    ('Terapi'),
    ('Perkantoran'),
    ('Interior'),
    ('Beauty Retail'),
    ('CCTV Store'),
    ('Toko Jam'),
    ('Teknologi'),
    ('Kosmetik'),
    ('Dealer'),
    ('Cafe'),
    ('Cuci Kendaraan'),
    ('Properti'),
    ('Tempat Les'),
    ('dll');

select * from kategori;

/* 4 - tabel produk
idProduk, tanggalInput, namaProduk, idKategori_fkProduk, deskripsiProduk */


insert into produk (namaProduk, deskripsiProduk)
values
	(/*-- REDACTED --*/);

/* Menambah values untuk produk 'SS' Susu Murni */
insert into produk (namaProduk, kodeProduk, deskripsiProduk)
values
	(/*-- REDACTED --*/);

/* Sekaligus Update kolom kodeProduk pada table produk */
UPDATE produk
SET kodeProduk = CASE
	WHEN idProduk = 1 THEN 'KodeProdukA'
	WHEN idProduk = 2 THEN 'KodeProdukB'
    WHEN idProduk = 3 THEN 'KodeProdukC'
	ELSE kodeProduk
END
WHERE idProduk IN (1,2,3);

select * from produk;

/* 5. tabel Interaksi */
insert into interaksi(tanggalFollowUp, followUpKe, catatan, idProfil_fkInteraksi)
values
	('2024-07-04', 0, 'Telp (Misscall semua)', 1);
/* Terdapat inputan tanggalFollowUp diatas sempat salah */
update interaksi
SET tanggalFollowUp = '2022-07-04', tanggalInput = now()
WHERE idInteraksi = 1;

describe profil;

/* Lanjut insert interaksi dibawah ini: */
insert into interaksi(tanggalFollowUp, followUpKe, catatan, idProfil_fkInteraksi, idStatus_fkInteraksi)
values
	/* Perusahaan ke-1 (idPerusahaan: 1) */
	('2022-07-11', 1, 'Telp (Feli): Ta titipkan tester di lokasi', 1, null),
    ('2022-10-10', 2, 'Tester + Proposal telah dititipkan', 1, null),
    /* Perusahaan ke-2 (idPerusahaan: 2) */
    ('2023-03-03', 0, 'Penawaran ke Owner', 2, 4)
    /* Perusahaan ke-3 (idPerusahaan: 3) */
    (/*-- Redacted --*/);
    
select * from perusahaan;
describe interaksi;
select * from interaksi;
select * from status;
select * from profil;

/* LIST STATUS:
1 - Blacklist (Hitam)
2 - Tanda Tanya? (Kuning)
3 - Misscall (Coklat pucat)
4 - Ga Prospek / Ga Mau Dulu (Merah gelap)
5 - Prospek (Hijau)
6 - FU Last on Progress (Abu2)
*/

/* --- */

/* 1 - tabel perusahaan (FK Is Null)
idPerusahaan, tanggalInput, idInteraksi_fkPerusahaan, tanggalKunjungan, namaPerusahaan, jenisUsaha, idProduk_fkPerusahaan, alamat, idProfil_fkPerusahaan */

select * from perusahaan;

/* 1.1.0 - Input Data Perusahaan Pertama (DN-D2D-*REDACTED*-24-FEB-2023) */
insert into perusahaan(tanggalKunjungan, namaPerusahaan, jenisUsaha)
value
	('2023-02-24', 'Perusahaan ke-1', 'Salon Kecantikan'),
    ('2023-02-24', 'Perusahaan ke-2', 'Salon Kecantikan'),
    ('2023-02-24', 'Perusahaan ke-3', 'Klinik Dr. Gigi'),
    /* ...Perusahaan lain - lainnya... */
    (/* --Redacted-- */);

/* tanggalKunjungan karena datatype DATE, maka formatnya YYYY/MM/DD */

/* 1.1.1 - Penyesuaian Kategori Perusahaan */
-- Showcase m:n implementation via SQL Query
insert into KategoriBanyak(pkPerusahaan_fkKategoriBanyak, pkKategori_fkKategoriBanyak)
values
	(1,1), (2,1), (3,2), (4,1), (5,1), (6,1), (7,1), (8,1), (9,1), (10,4), (11,5), (12,1),
    (13,1), (14,1), (14,5), (15,5), (16,6), (17,1), (17,5), (18,1), (19,5), (20,19), (21,5),
    (22,6), (23,1), (24,6), (25,6), (26,1), (27,7), (28,8), (29,1), (30,1), (31,2), (32,1),
    (33,1), (34,1), (35,1), (36,1), (37,3), (38,4), (39,5), (40,1), (41,1), (42,1), (42,5),
    (43,5), (44,6), (45,1), (45,5), (46,1), (47,5), (48,19), (49,5), (50,6), (51,1), (52,6),
    (53,6), (54,1), (55,7), (56,8);

select * from perusahaan;
select * from kategori;
/*
1 - Salon			2 - Klinik
3 - Beauty Bar		4 - Cleaning
5 - Barbershop		6 - Terapi
7 - Perkantoran		8 - Interior
9 - Beauty Retail	10 - CCTV Store
11 - Toko Jam		12 - Teknologi
13 - Kosmetik		14 - Dealer
15 - Cafe			16 - Cuci Kendaraan
17 - Properti		18 - Tempat Les
19 - DLL
*/

select * from kategoribanyak;

describe perusahaan;

/* RALAT: DIKARENAKAN Query Perusahaannya Kedobelan yang seharusnya terdapat total
28 Database perusahaan, maka diperlukan penyesuaian dari total 56 Database Perusahaan
menjadi 28 Database Perusahaan sebagai berikut: */

delete from kategoribanyak
where idKategoriBanyak > 30;

delete from perusahaan
where idPerusahaan > 28;

select * from perusahaan;

/* 2 - tabel profil (FK Is Null)
idProfil, tanggalInput, namaKontak, jabatan, idKontak_fkProfil*/

insert into profil (namaKontak, jabatan)
values
	('Bu A', 'Manager'),
    ('Ko B', 'Owner'),
    ('Mas C', 'Karyawan'),
    ('Mbak D', 'Pegawai'),
    ('Pak E', 'Owner (Dugaan)'),
    ('Bro F', 'Owner'),
    ('Mbok G', 'Manajemen'),
    ('Sis H', 'Cabang PTC'),
    /* ... insert profil secukupnya ... */
    (/* -- Redacted -- */);

select * from profil;
select * from perusahaan;

/* 3 - tabel kontak (FK Is Null)
idKontak, tanggalInput, alamatCabang, nomorWA, email, idKontakSekunder_fkKontak*/

insert into kontak (alamatCabang, nomorWA, email)
values
	('Mal Kayangan Blok A Lt LG', '0861-3456-7890', null),
    ('Mal Kayangan Blok A2 no 1 Lt. LG', '0862-1234-5678', null),
    /* ...Insert kontak berdasarkan alamat cabang, no WA, dan email... */
    (/* -- Redacted -- */);
    
/* Update Inputan Email pada Row 'Bapak I (contoh nama samaran)' dan dibawahnya */
UPDATE kontak
SET email = CASE 
    WHEN idKontak = 32 THEN 'example1@gmail.com'
    WHEN idKontak = 35 THEN 'example2@gmail.com'
    WHEN idKontak = 36 THEN 'example3@gmail.com'
    ELSE email  -- Keeps the current value for other rows
END
WHERE idKontak IN (32, 35, 36);

/* Yang inputnya ketinggalan Kereta */
insert into kontak (alamatCabang, nomorWA, email)
values
	('Mall Kayangan, Lt.2 Blok E3. No.211', null, null), /* Input ke PK Ko A, Owner */
	('Mall Kayangan A1 No 2B Lt. 1', '012-345 4321', null), /* Input ke PK Bro B, Karyawan */
	('Ruko Mimpi Indah Unit 1001', null, null), /* Input ke PK Sis G, Karyawan */
    (null, '0866-6666-6666', null); /* Input ke PK Sis G, Karyawan */

/* Ketinggalan Kereta Ke-2: Ruko Hajatan */
insert into kontak (alamatCabang, nomorWA, email)
values
	('Ruko Hajatan Gang V', null, null);

select * from kontak;

/* 4 - tabel kontaksekunder
idKontakSekudner, tanggalInput, instagram, facebook, twitterX, situsWeb, tokopedia, shopee */

insert into kontaksekunder (instagram, facebook, twitterX, situsWeb, tokopedia, shopee)
values
	('@akunIG_A', null, null, null, null, null),
    ('@akunIG_B', null, null, null, null, null),
    ('@akunIG_C', null, null, null, null, null),
    ('@akunIG_D', null, null, null, null, null),
    (null, null, null, 'example.com', null, null),
    ('@akunIG_E', null, null, null, null, null),
    ('@akunIG_F', null, null, null, null, null),
    ('@akunIG_G', null, null, null, null, null);

select * from kontaksekunder;

/* Sampai disini, hubungkan Relasi DB antar-Kontak, Perusahaan diatas:

1 - Kontak & Kontaksekunder*/
UPDATE kontak
SET idKontakSekunder_fkKontak = CASE 
	/* IG: @akunIG_A, kontak: 0866-1234-5678 dan 0867-9876-5432 */
    WHEN idKontak = 2 THEN 1
    WHEN idKontak = 3 THEN 1
    /* IG: @akunIG_B, kontak: 0866-4321-1234 (WA) */
    WHEN idKontak = 4 THEN 2
    /* IG: @akunIG_C, kontak: 0869-1265-3671 (WA) dan 0868-1514-5609 (WA) */
    WHEN idKontak = 6 THEN 3
    WHEN idKontak = 7 THEN 3
    /* IG: @akunIG_D, Alamat: Mall Kenayangan, Jl. Hajatan, dan Mall Mimpi Lt. 2 No. 3 */
    WHEN idKontak = 9 THEN 4
    WHEN idKontak = 10 THEN 4
    /* WHEN idKontak = ..?.. THEN 4 .... << Alamat Mall Mimpi belum ada */
    /* Situs Web: example.com, WA: 0867-6767-1212, Alamat: Lokasi Malang */
    WHEN idKontak = 11 THEN 5
    WHEN idKontak = 12 THEN 5
    /* IG: @akunIG_E, WA: 0861-2345-6789 (WA) */
    WHEN idKontak = 26 THEN 6
    /* IG: @akunIG_F, WA: 0862-1321-2345 */
    WHEN idKontak = 32 THEN 7
    /* IG: @akunIG_G, Email: akunG_example@email.com */
    WHEN idKontak = 35 THEN 8
    WHEN idKontak = 36 THEN 8
    ELSE idKontakSekunder_fkKontak  -- Keeps the current value for other rows
END
WHERE idKontak IN (2, 3, 4, 6, 7, 9, 10, 11, 12, 26, 32, 35, 36);

select * from kontak;
select * from kontaksekunder;

/* 2 - Perusahaan & Interaksi (Sudah Selesai Diquery diatas). */
select * from perusahaan;
select * from interaksi;

/* 3.1 - Perusahaan & Kategori (ga perlu, karena sifatnya ini M:N yakni Many-to-Many
dan SUDAH DIUPDATE) */

/* 3.2 - Perusahaan & Produk (Done dibawah) */
select * from perusahaan;
select * from produk;
select * from produkbanyak;

insert into produkbanyak (idPerusahaan_fkProdukBanyak, idProduk_fkProdukBanyak)
VALUES
	(1,1), (2,1), (3,1), (4,1), (5,1), (6,1), (7,1), (8,1), (9,1), (11,1), (12,1), (13,1),
    (14,1), (15,1), (16,1), (17,1), (18,1), (19,1), (20,1), (21,1), (22,1), (23,1), (24,1),
    (25,1), (26,1), (27,1), (28,1);

/* List Produk:
1: produkKodeA
2. produkKodeB
3. produkKodeC
*/

select * from produkbanyak;

/* 4 - Perusahaan & Profil (Selesai) */

insert into profilbanyak(idPerusahaan_fkProfilBanyak, idProfil_fkProfilBanyak)
VALUES
	(1,1), (2,2), (3,3), (4,4), (5,5), (6,6), (7,7), (8,8), (9,9), (10,10), (11,11), (12,12),
    (13,13), (14,14), (15,15), (16,16), (17,17), (18,18), (19,19), (20,20), (21,21), (22,22), 
    (23,23), (24,24), (25,25), (26,26), (27,27), (28,28);

select * from perusahaan;
select * from profil;
select * from profilbanyak;
/* Kenapa table profilbanyak? Karena ada yang 1 Perusahaan, terdapat >2 Owner */

/* Untuk FK sudah saling terhubung, tinggal menghubungi QUERY FK nya saja. */

/* 5 - tabel interaksi (DONE, Sudah di Query diatas.)
idInteraksi, tanggalInput, tanggalFollowUp, followUpKe, catatan
*/

select * from interaksi;

/*
Terpisah dari atas, lanjutannya adalah KODE RESI:

1 - Table KodeTanggal
idKodeTanggal, tanggalInput, hari, bulan, tahun */

insert into kodetanggal (hari, bulan, tahun)
VALUES (24, 2, 2023);

/* ganti dari 2 jadi 'FEB' pada kolom bulan, setelah dirubah jadi varchar(100) */
update kodetanggal
set bulan = 'FEB'
where idKodeTanggal = 1;

select * from kodetanggal;

/* 2 - Table MetodeJualan
idMetodeJualan, tanggalInput, metodeJualan */
/* NOTE: MetodeJualan sudah berupa List Selection, tidak perlu Insert disini lagi.
Sudah dilakukan diatas. */
select * from metodejualan;

/*3 - Table KodeTempat
idKodeTempat, tanggalInput, namaTempat, lantai, blok */

insert into KodeTempat(namaTempat, lantai, blok)
VALUES ('Mall Kayangan', 'LG', 'BlokA');

select * from kodetempat;

/*4 - Table SKU Daftar Nama
idSkuDaftarNama, tanggalInput, idMetodeJualan_fk, idKodeTempat_fk, catatanTambahan */
/* NOTE!! Untuk skuDaftarNama bagian Primary Key WAJIB DIISI MANUAL! */

select * from skudaftarnama;
select * from kodetempat;

/* URUTAN KODE RESI BERDASARKAN URUTAN TABEL:
1 - metodejualan
2 - kodetempat
3 - produk
4 - kodetanggal
*/

/* ......(Yang pada tempat bagian atas "1 - DN", bikin disini saja)....

/* Dari sini, Inputkan Resi DN untuk 'DN-D2D-MALL-REDACTED-24-FEB-2023' : */
insert into skuDaftarNama(idSkuDaftarNama, idMetodePenjualan_fkSkuDaftarNama, idKodeTempat_fkSkuDaftarNama, idProduk_fkSkuDaftarNama, idKodeTanggal_fkSkuDaftarNama, catatanTambahan)
VALUES ('RDN001',1,1,1,1, 'Hasil Door-2-Door selama di Mall Kenangan');

update skuDaftarNama
SET catatanTambahan = 'Hasil Door-2-Door selama di Mall Kenangan pada tanggal 2 Maret 2024'
WHERE idSkuDaftarNama = 'RDN001';

SELECT * from skuDaftarNama;
describe skuDaftarNama;
select * from metodeJualan;
select * from kodeTempat;
select * from produk;
select * from kodeTanggal;
use daftarnama_palugada;

/* Saatnya mengintegrasikan sekumpulan List DN
dibawah Resi 'DN-D2D-MALL-REDACTED-24-FEB-2023' : */

UPDATE perusahaan
SET idSkuDaftarNama_fkPerusahaan = CASE 
    WHEN idPerusahaan = 1 THEN 'RDN001'
    WHEN idPerusahaan = 2 THEN 'RDN001'
    WHEN idPerusahaan = 3 THEN 'RDN001'
    WHEN idPerusahaan = 4 THEN 'RDN001'
    WHEN idPerusahaan = 5 THEN 'RDN001'
    WHEN idPerusahaan = 6 THEN 'RDN001'
    WHEN idPerusahaan = 7 THEN 'RDN001'
    WHEN idPerusahaan = 8 THEN 'RDN001'
    WHEN idPerusahaan = 9 THEN 'RDN001'
    WHEN idPerusahaan = 10 THEN 'RDN001'
    WHEN idPerusahaan = 11 THEN 'RDN001'
    WHEN idPerusahaan = 12 THEN 'RDN001'
    WHEN idPerusahaan = 13 THEN 'RDN001'
    WHEN idPerusahaan = 14 THEN 'RDN001'
    WHEN idPerusahaan = 15 THEN 'RDN001'
    WHEN idPerusahaan = 16 THEN 'RDN001'
    WHEN idPerusahaan = 17 THEN 'RDN001'
    WHEN idPerusahaan = 18 THEN 'RDN001'
    WHEN idPerusahaan = 19 THEN 'RDN001'
    WHEN idPerusahaan = 20 THEN 'RDN001'
    WHEN idPerusahaan = 21 THEN 'RDN001'
    WHEN idPerusahaan = 22 THEN 'RDN001'
    WHEN idPerusahaan = 23 THEN 'RDN001'
    WHEN idPerusahaan = 24 THEN 'RDN001'
    WHEN idPerusahaan = 25 THEN 'RDN001'
    WHEN idPerusahaan = 26 THEN 'RDN001'
    WHEN idPerusahaan = 27 THEN 'RDN001'
    WHEN idPerusahaan = 28 THEN 'RDN001'
    ELSE idSkuDaftarNama_fkPerusahaan  -- Keeps the current value for other rows
END
WHERE idPerusahaan IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28);

select * from perusahaan;
select * from skudaftarnama;
select * from interaksi;

/* PADA TABEL PERUSAHAAN: Update Alamat Inti & Deskripsi Inti disini: */
/* --- */

/* 5 - Table Kontak Sekunder Banyak */
insert into kontaksekunderbanyak(idKontak_fkKontakSekunderBanyak, idKontakSekunder_fkKontakSekunderBanyak)
	VALUES
		(2,1),(3,1),(4,2),(6,3),(7,3),(9,4),(10,4),(11,5),(12,5),(26,6),(32,7),(35,8),(36,8);

/* Cek disini untuk memastikan ulang Kontak Sekunder yang m:n telah terupdate di table
kontaksekunderbanyak : */
select * from perusahaan;
select * from profil;
select * from kontak;
select * from kontaksekunder;
select * from kontaksekunderbanyak;

/* 6 - Table Profil dihubung dengan Table Kontak (Lupa dengan ini) */
select * from kontak;
update kontak
set idProfil_fkKontak = CASE
	/* 1 - Bu A (Manager) */
    when idKontak = 1 then 1
    /* 2 - Ko B (Owner) */
    when idKontak = 2 then 2
    when idKontak = 3 then 2
    /* 3 - Bro C (Karyawan) */
    when idKontak = 4 then 3
    /* 4 - Bu D (Pegawai) */
    when idKontak = 5 then 4
    /* 5 - ? (Owner (dugaan)) */
    when idKontak = 6 then 5
    when idKontak = 7 then 5
    /* 6 - Pak E (Owner) */
    when idKontak = 8 then 6
    /* 7 - ? (manajemen) */
    when idKontak = 9 then 7
    when idKontak = 10 then 7
    /* 8 - Cabang Mall Kayangan */
    when idKontak = 11 then 8
	/* 9 - ? (manajemen) */
    when idKontak = 12 then 9
    /* 10 - (Nomor di Toko Mall Kayangan) */
    when idKontak = 13 then 10
    /* 11 - Bro F.. (Owner) */
    when idKontak = 14 then 11
    /* 12 - Kak G (Owner) */
    when idKontak = 15 then 12
    /* 13 - Ce H (Owner) */
    when idKontak = 16 then 13
    /* 14 - Pak I (Owner) */
    when idKontak = 17 then 14
    /* 15 - Om J (Owner) */
    when idKontak = 18 then 15
    /* 16 - Cik K (Owner) */
    when idKontak = 19 then 16
    /* 17 - ? (Nomor Cabang di...) */
	when idKontak = 20 then 17
    /* 18 - Ko L (Owner) */
    when idKontak = 21 then 18
    /* 19 - Sis M (Owner) */
    when idKontak = 22 then 19
    /* 20 - Pak O atau... (Owner) */
    when idKontak = 23 then 20
    when idKontak = 24 then 20
    when idKontak = 25 then 20
    /* 21 - Sis P (Owner) */
    when idKontak = 26 then 21
    /* 22 - Ibu Q (Owner) */
    when idKontak = 27 then 22
    /* 23 - ? (Nomor Salon) */
    when idKontak = 28 then 23
    /* 24 - Bu R (SPV) */
    when idKontak = 29 then 24
    /* 25 - ? (Nomor Cabang Mall Kayangan) */
    when idKontak = 30 then 25
    /* 26 - Pak S (SPV) */
    when idKontak = 31 then 26
    /* 27 - Ibu T... (Owner) */
    when idKontak = 32 then 27
    when idKontak = 33 then 27
    when idKontak = 34 then 27
    /* 28 - ? (?) */
    when idKontak = 35 then 28
    when idKontak = 36 then 28
	else idProfil_fkKontak
end
where idKontak in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36);
/* Ehh ada kelupaan update kontak dgn idKontak = 37 untuk profil dengan idProfil = 9 */
update kontak
set idProfil_fkKontak = 9
where idKontak = 37;

/* Untuk memastikan table profil dengan kontak sudah saling terhubung: */
select * from perusahaan;
select * from profil;
select * from kontak;

select * from skudaftarnama;