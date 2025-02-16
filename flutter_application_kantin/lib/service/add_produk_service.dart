import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/model/add_produk.dart';

class ProductService {
  static const String baseUrl =
      "https://ats-714220023-serlipariela-38bba14820aa.herokuapp.com";

  Future<bool> addProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add-product'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: json.encode(product.toJson()),
      );

      print("Response Code: \${response.statusCode}");
      print("Response Body: \${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Error: \$e");
      return false;
    }
  }
}
