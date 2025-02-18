// product_service.dart
import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter_application_1/model/delete_update.produk.dart';


class ProdukServices{
  final Dio dio = Dio();
  final String _baseUrl =   "https://ats-714220023-serlipariela-38bba14820aa.herokuapp.com";

   // Fungsi untuk mengambil data produk
  Future<List<Product>> getProducts() async {
    try {
      final response = await dio.get('$_baseUrl/produk');

      if (response.statusCode == 200) {
        final data = response.data;
        print("Data produk: $data");  // Debug print untuk memeriksa struktur data

        // Mengambil data dari key "data" dan mengkonversi ke List<Product>
        List<dynamic> productData = data['data']; // Sesuaikan dengan struktur response yang ada
        return productData.map((json) => Product.fromJson(json)).toList();
      } else {
        print('Failed to load products');
        return [];
      }
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  // Fungsi untuk menghapus produk
  Future<bool> deleteProduct(String id) async {
    try {
      final response = await dio.delete('$_baseUrl/deleteproduk/$id');
      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting product: $e');
      return false;
    }
  }

  // Fungsi untuk memperbarui produk
  Future<bool> updateProduct(Product product) async {
    try {
      final response = await dio.put(
        '$_baseUrl/updateproduk/${product.id}',
        data: {
          "nama_produk": product.namaProduk,
          "deskripsi": product.deskripsi,
          "harga": product.harga,
          "gambar": product.gambar,
          "stok": product.stok,
          "kategori": product.kategori,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating product: $e');
      return false;
    }
  }
}
