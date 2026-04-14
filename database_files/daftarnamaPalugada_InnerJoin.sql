/* Bagian InnerJoin */
use daftarnama_palugada;

select * from profilbanyak;
select * from perusahaan;
select * from profil;

/*  MENAMPILKAN JOIN TABLE YANG M:N TABLE */
/* 1 - kategoribanyak */
select p.idSkuDaftarNama_fkPerusahaan, p.namaPerusahaan, p.jenisUsaha, k.namaKategori
from perusahaan p
join kategoribanyak kb on p.idPerusahaan = kb.pkPerusahaan_fkKategoriBanyak
join kategori k on k.idKategori = kb.pkKategori_fkKategoriBanyak;

select * from perusahaan;
select * from kategori;
select * from kategoribanyak;

/* 2 - kontaksekunderbanyak */
select p.namaKontak, p.jabatan, k.alamatCabang, k.nomorWA, ks.instagram, ks.facebook,
ks.twitterX, ks.situsWeb, ks.tokopedia, ks.shopee
from profil p
join kontak k on (p.idProfil = k.idProfil_fkKontak)
join kontaksekunderbanyak ksb on (k.idKontak = ksb.idKontak_fkKontakSekunderBanyak)
join kontaksekunder ks on (ksb.idKontakSekunder_fkKontakSekunderBanyak = ks.idKontakSekunder);

select * from profil;
select * from kontak;
select * from kontaksekunder;
select * from kontaksekunderbanyak;

/* 3 - produkbanyak */
select pe.namaPerusahaan, pe.jenisUsaha, p.namaProduk, p.kodeProduk
from perusahaan pe
join produkbanyak pb on (pe.idPerusahaan = pb.idPerusahaan_fkProdukBanyak)
join produk p on (p.idProduk = pb.idProduk_fkProdukBanyak);

select * from perusahaan;
select * from produk;
select * from produkbanyak;

/* 4 - profilbanyak */
select pe.namaPerusahaan, pe.jenisUsaha, p.namaKontak, p.jabatan
from perusahaan pe
join profilbanyak pb on (pb.idPerusahaan_fkProfilBanyak = pe.idPerusahaan)
join profil p on (p.idProfil = pb.idProfil_fkProfilBanyak);

select * from perusahaan;
select * from profil;
select * from profilbanyak;

/* SEKARANG BERDASARKAN DATA DARI STRUKTUR DAFTAR NAMA SELURUH */

/* 1 - Resi DN */
/*Ini Contohnya: DN-D2D-PTC-Lantai-LG-BlokA-DES-24-FEB-2023 */
select sku.idSkuDaftarNama, mj.kodeMetodeJualan, kt.namaTempat, kt.lantai, kt.blok,
p.kodeProduk, ktg.hari, ktg.bulan, ktg.tahun
from skuDaftarNama sku
join metodeJualan mj on (mj.idMetodeJualan = sku.idMetodePenjualan_fkSkuDaftarNama)
join kodetempat kt on (kt.idKodeTempat = sku.idKodeTempat_fkSkuDaftarNama)
join produk p on (p.idProduk = sku.idProduk_fkSkuDaftarNama)
join kodetanggal ktg on (ktg.idKodeTanggal = sku.idKodeTanggal_fkSkuDaftarNama);

select * from skudaftarnama;
select * from metodejualan;
select * from kodetempat;
select * from produk;
select * from kodetanggal;

/*
sku = skudaftarnama
mj = metodejualan
kt = kodetempat
p = produk
ktg = kodetanggal
*/

select * from perusahaan;

/* 2 - Struktur DaftarNama */
/* Jika berdasarkan struktur Tabel:
SKU-DN, Nama Perusahaan, Jenis Usaha, Produk / Layanan Ditawarkan, Nama Kontak, Jabatan,
Alamat, Kontak, Email, Kontak Tambahan, Catatan / Deskripsi Singkat

Yang ini ditampilkan pada Halaman Khusus Tersendiri:
1. Yang Follow Up (Interaksi)
2. Profil Per user (bagian terakhir ada deskripsi).
Karena No 1 dan 2 diatas ada bagian kolom 'Deskripsi'
 */
 
 select * from kontak;