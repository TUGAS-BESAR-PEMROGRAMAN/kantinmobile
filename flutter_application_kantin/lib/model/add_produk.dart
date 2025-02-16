import 'dart:convert';

class Product {
  String namaProduk;
  String deskripsi;
  double harga;
  String gambar;
  int stok;
  String kategori;

  Product({
    required this.namaProduk,
    required this.deskripsi,
    required this.harga,
    required this.gambar,
    required this.stok,
    required this.kategori,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      namaProduk: json['nama_produk'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      harga: (json['harga'] as num?)?.toDouble() ?? 0.0,
      gambar: json['gambar'] ?? '',
      stok: (json['stok'] as num?)?.toInt() ?? 0,
      kategori: json['kategori'] ?? '',
    );
  }

  get id => null;

  Map<String, dynamic> toJson() {
    return {
      "nama_produk": namaProduk,
      "deskripsi": deskripsi,
      "harga": harga,
      "gambar": gambar,
      "stok": stok,
      "kategori": kategori,
    };
  }

  String toRawJson() => json.encode(toJson());
}
