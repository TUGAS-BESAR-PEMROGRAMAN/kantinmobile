import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/model/chart_item.dart';

class CartService {
  static const String _baseUrl =
      "https://ats-714220023-serlipariela-38bba14820aa.herokuapp.com";

  Future<void> addToCart(CartItem item) async {
    final url = Uri.parse("$_baseUrl/insertchartitem");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(item.toJson()),
      );

      if (response.statusCode == 200) {
        print("Item berhasil ditambahkan ke keranjang.");
      } else {
        print("Gagal menambahkan item: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
