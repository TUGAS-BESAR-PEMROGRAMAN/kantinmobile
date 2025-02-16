import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/model/add_produk.dart';
import 'package:flutter_application_1/service/add_produk_service.dart';

class DashboardAdmin extends StatelessWidget {
  final ProductService productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 191, 42),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 233, 170, 9),
        title: Text(
          'Admin Dashboard',
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.logOut, color: Colors.white),
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
              'Manage Your Products',
              style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 3, 3, 3)),
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
                    _buildCard('', LucideIcons.layout,
                        const Color.fromARGB(255, 0, 140, 255)),
                    _buildCard('Add Product', LucideIcons.plusCircle,
                        const Color.fromARGB(255, 149, 164, 176), context),
                    _buildCard('Products', LucideIcons.box,
                        const Color.fromARGB(255, 164, 170, 176)),
                    _buildCard('', LucideIcons.layout, Colors.blue.shade600),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Effortless product management at your fingertips!',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: const Color.fromARGB(255, 0, 0, 0)),
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
            const SizedBox(height: 8),
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
                  if (value != null) {
                    kategori = value;
                  }
                },
                decoration: const InputDecoration(labelText: 'Kategori'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (namaController.text.isEmpty ||
                  deskripsiController.text.isEmpty ||
                  hargaController.text.isEmpty ||
                  gambarController.text.isEmpty ||
                  stokController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Semua kolom harus diisi!')),
                );
                return;
              }

              Product newProduct = Product(
                namaProduk: namaController.text,
                deskripsi: deskripsiController.text,
                harga: double.tryParse(hargaController.text) ?? 0.0,
                gambar: gambarController.text,
                stok: int.tryParse(stokController.text) ?? 0,
                kategori: kategori,
              );

              bool success = await productService.addProduct(newProduct);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success
                      ? 'Produk "${newProduct.namaProduk}" berhasil ditambahkan! 🎉'
                      : 'Gagal menambahkan produk: ${newProduct.namaProduk}. Pastikan data benar dan coba lagi! ❌'),
                  backgroundColor: success ? Colors.green : Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Submit'),
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
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
