// product_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/model/delete_update.produk.dart';

class ProductService {
  static const String baseUrl =
      "https://ats-714220023-serlipariela-38bba14820aa.herokuapp.com";

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/produk'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<bool> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/deleteproduk/$id'));
    return response.statusCode == 200;
  }

  Future<bool> updateProduct(Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/updateproduk/${product.id}'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "nama_produk": product.namaProduk,
        "deskripsi": product.deskripsi,
        "harga": product.harga,
        "gambar": product.gambar,
        "stok": product.stok,
        "kategori": product.kategori,
      }),
    );
    return response.statusCode == 200;
  }
}
