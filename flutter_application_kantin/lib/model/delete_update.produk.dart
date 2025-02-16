class Product {
  String id;
  String namaProduk;
  String deskripsi;
  double harga;
  String gambar;
  int stok;
  String kategori;

  Product({
    required this.id,
    required this.namaProduk,
    required this.deskripsi,
    required this.harga,
    required this.gambar,
    required this.stok,
    required this.kategori,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      namaProduk: json['nama_produk'],
      deskripsi: json['deskripsi'],
      harga: (json['harga'] as num).toDouble(),
      gambar: json['gambar'],
      stok: (json['stok'] as num).toInt(),
      kategori: json['kategori'],
    );
  }
}
