class CartItem {
  final String idProduk;
  final String namaProduk;
  final int harga;
  final int jumlah;

  CartItem({
    required this.idProduk,
    required this.namaProduk,
    required this.harga,
    this.jumlah = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      "id_produk": idProduk,
      "nama_produk": namaProduk,
      "harga": harga,
      "jumlah": jumlah,
    };
  }
}
