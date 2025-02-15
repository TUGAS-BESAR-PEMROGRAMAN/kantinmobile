import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'Dashboard Admin',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(LucideIcons.logOut, color: Colors.white),
            onPressed: () {
              // Tambahkan fungsi logout di sini
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '',
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  children: [
                    _buildCard(
                        '', LucideIcons.activitySquare, Colors.orange.shade300),
                    _buildCard('Add Product', LucideIcons.shoppingCart,
                        Colors.orange.shade400, context),
                    _buildCard(
                        'Products', LucideIcons.box, Colors.orange.shade500),
                    _buildCard('', LucideIcons.rainbow, Colors.orange.shade600),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Manage your store efficiently and easily!',
              style: GoogleFonts.poppins(
                  fontSize: 16, color: Colors.orange.shade700),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, Color color,
      [BuildContext? context]) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: color,
      elevation: 4,
      child: InkWell(
        onTap: () {
          if (title == 'Add Product' && context != null) {
            _showAddProductForm(context);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.white),
            SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProductForm(BuildContext context) {
    final TextEditingController namaController = TextEditingController();
    final TextEditingController deskripsiController = TextEditingController();
    final TextEditingController hargaController = TextEditingController();
    final TextEditingController gambarController = TextEditingController();
    final TextEditingController stokController = TextEditingController();
    String kategori = 'Makanan';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Product', style: GoogleFonts.poppins()),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(namaController, 'Nama Produk'),
              _buildTextField(deskripsiController, 'Deskripsi'),
              _buildTextField(hargaController, 'Harga', TextInputType.number),
              _buildTextField(gambarController, 'Gambar URL'),
              _buildTextField(stokController, 'Stok', TextInputType.number),
              DropdownButtonFormField<String>(
                value: kategori,
                items: ['Makanan', 'Minuman']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  kategori = value!;
                },
                decoration: InputDecoration(labelText: 'Kategori'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              bool success = await _submitProduct(
                namaController.text,
                deskripsiController.text,
                hargaController.text,
                gambarController.text,
                stokController.text,
                kategori,
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(success
                        ? 'Produk berhasil ditambahkan!'
                        : 'Gagal menambahkan produk. Coba lagi.')),
              );
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      [TextInputType keyboardType = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        keyboardType: keyboardType,
      ),
    );
  }

  Future<bool> _submitProduct(String nama, String deskripsi, String harga,
      String gambar, String stok, String kategori) async {
    final url = Uri.parse(
        'https://ats-714220023-serlipariela-38bba14820aa.herokuapp.com/add-product');
    final Map<String, dynamic> data = {
      'nama_produk': nama,
      'deskripsi': deskripsi,
      'harga': double.tryParse(harga) ?? 0,
      'gambar': gambar,
      'stok': int.tryParse(stok) ?? 0,
      'kategori': kategori,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
