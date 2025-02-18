// class product
class Product {
  final String id;
  final String namaProduk;
  final String deskripsi;
  final double harga;
  final String gambar;
  final int stok;
  final String kategori;

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
      stok: json['stok'],
      kategori: json['kategori'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "nama_produk": namaProduk,
      "deskripsi": deskripsi,
      "harga": harga,
      "gambar": gambar,
      "stok": stok,
      "kategori": kategori,
    };
  }
}
// class produk input
class ProductInput {
  final String namaProduk;
  final String deskripsi;
  final double harga;
  final String gambar;
  final int stok;
  final String kategori;

  ProductInput({
    required this.namaProduk,
    required this.deskripsi,
    required this.harga,
    required this.gambar,
    required this.stok,
    required this.kategori,
  });

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
}

class ProductResponse {
  final String createdAt;
  final String? insertedId;
  final String message;
  final int status;

  ProductResponse({
    required this.createdAt,
    this.insertedId,
    required this.message,
    required this.status,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      createdAt: json["created_at"],
      insertedId: json["inserted_id"],
      message: json["message"],
      status: json["status"],
    );
  }
}
